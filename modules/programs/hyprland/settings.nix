{
  lib,
  pkgs,
  config,
  xLib,
  ...
}: let
  inherit (lib) mkOption types mkDefault getExe getExe' optionalAttrs mkIf;
  inherit (builtins) baseNameOf concatLists genList isString;
  cfg = config.cfg.programs.hyprland;
  multiMonitor = cfg.secondaryMonitor != null;
  brightnessScript =
    if multiMonitor
    then "brightness.sh"
    else "brightness-laptop.sh";
  wsAnim =
    if multiMonitor
    then "slidevert"
    else "slide";

  toggleProc = pkg: let
    exe =
      if isString pkg
      then pkg
      else getExe pkg;
    binaryName =
      if isString pkg
      then exe
      else baseNameOf exe;
  in "pkill ${binaryName} || ${exe}";

  runOnce = pkg: let
    exe =
      if isString pkg
      then pkg
      else getExe pkg;
    binaryName =
      if isString pkg
      then exe
      else baseNameOf exe;
  in "pgrep ${baseNameOf binaryName} || ${exe}";

  sunsetScript = pkgs.writeShellApplication {
    name = "sunset";
    runtimeInputs = [
      config.programs.hyprland.package # provides hyprctl
    ];
    text = ''
      if [ -e /tmp/sunsetLock ]; then
        echo "Resetting temperature"
        hyprctl hyprsunset identity
        rm /tmp/sunsetLock
      else
        echo "Setting temperature to $1"
        hyprctl hyprsunset temperature "$1"
        touch /tmp/sunsetLock
      fi
    '';
  };

  screenshotScript = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [
      libcanberra-gtk3
      jq
      grim
      slurp
      wl-clipboard
      wayfreeze
    ];
    text = ''
      # Screenshot the entire monitor, a selection, or active window
      # and then copies the image to your clipboard.
      # It also saves the image locally.

      fileName="Screenshot from $(date '+%y.%m.%d %H:%M:%S').png"
      screenshotDir="$HOME/Pictures/Screenshots"
      path="$screenshotDir/$fileName"
      grimCmd="grim -t png -l 1"

      # make the screenshot directory if it doesn't already exist
      if [ ! -d "$screenshotDir" ]; then
        mkdir -p "$screenshotDir"
        echo "Directory '$screenshotDir' created successfully."
      fi

      case $1 in
      --monitor)
        if [ -z "$2" ]; then
          echo "give monitor output too"
          exit 1
        fi
         $grimCmd -o "$2" "$path"
        ;;
      --selection)
        wayfreeze --hide-cursor &
        PID=$!
        sleep .1
        # don't allow multiple slurps at once
        pidof slurp || ($grimCmd -g "$(slurp)" "$path" || echo "selection cancelled")
        kill $PID
        ;;
      --active)
        window_geometry=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        $grimCmd -g "$window_geometry" "$path" || echo "no active window"
        ;;
      esac

      # if the screenshot was successful
      if [ -f "$path" ]; then
        canberra-gtk-play -i camera-shutter & # play shutter sound
        dunstify -i "$path" -a "screenshot" "Screenshot" "Copied to clipboard" -r 9998 &
        wl-copy < "$path" # copy to clipboard
        exit 0
      fi

      echo "Screenshot cancelled."
      exit 1
    '';
  };
in {
  options.cfg.programs = {
    hyprland = {
      defaultMonitor = mkOption {
        type = types.str;
        default = "DP-1";
        description = "Sets the default monitor for hypr*";
      };
      secondaryMonitor = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Sets the secondary monitor for hypr*.";
      };
    };
  };
  config = {
    hj = {
      packages = [
        screenshotScript
      ];
      xdg.config.files."hypr/hyprland.conf" = {
        generator = xLib.generators.toHyprlang {
          topCommandsPrefixes = [
            "$"
            "bezier"
            "source"
            "exec-once"
            "exec-shutdown"
          ];
        };
        value = {
          exec-once = [
            "dbus-update-activation-environment --systemd --all; systemctl --user stop hyprland-session.target; systemctl --user start hyprland-session.target"
          ];
          exec = [
            "${getExe pkgs.xorg.xrandr} --output ${cfg.defaultMonitor} --primary"
            "pgrep ags || ags"
          ];
          monitor = [
            ", preferred, auto, 1" # set 1x scale for all monitors which are undefined here. should be a good default.
            "desc:BOE, 1920x1080@60, 0x0, 1" # fazziGO internal monitor
            "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 23080B004543, 2560x1440@170, 0x0, 1" # kunzozPC monitor
            "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 20120B000001, 2560x1440@176, 0x0, 1" # fazziPC monitor
            "desc:Philips, 1920x1080@75,auto-center-left, 1" # place to the left of fazziPC monitor
          ];
          render = {
            direct_scanout = 1;
            # HACK: gamescope is broken with color-management.
            # see: https://github.com/ValveSoftware/gamescope/issues/1825
            cm_enabled = !config.cfg.programs.gamescope.enable;
          };
          cursor = {
            default_monitor = mkIf multiMonitor "${cfg.defaultMonitor}";
            sync_gsettings_theme = 0; # we handle this ourselves
            inactive_timeout = 4; # after x seconds of inactivity, hide the cursor
          };
          opengl = {
            nvidia_anti_flicker = 0;
          };
          input = {
            repeat_rate = 55; # Set characters to repeat on hold every 55ms
            repeat_delay = 375; # Set repeat timeout to 375ms
            follow_mouse = 2; # Follow mouse clicks for window focus
            accel_profile = "flat"; # disable all mouse accel by default
            float_switch_override_focus = 0; # Stop floating windows from stealing focus
            # i hate caps lock, so make it escape instead. also reset f13-f24 to their expected keysyms.
            kb_options = "fkeys:basic_13-24, caps:escape";
            # don't set tablet settings if opentabletdriver is enabled.
            tablet = optionalAttrs (!config.cfg.services.opentabletdriver.enable) {
              left_handed = 1; # inverted tablet
              output = "${cfg.defaultMonitor}";
              # active_area_size = "130, 73";
            };
            touchpad = {
              natural_scroll = true;
            };
          };
          "device[at-translated-set-2-keyboard]" = {
            kb_layout = "gb";
          };
          "device[elan0680:00-04f3:320a-touchpad]" = {
            accel_profile = "adaptive";
          };
          gestures = {
            workspace_swipe = true;
          };
          general = {
            gaps_out = 4; # Outer monitor gaps
            gaps_in = 2; # Inner window gaps
            border_size = 2; # Set window border width
            allow_tearing = 0;
          };
          misc = {
            new_window_takes_over_fullscreen = 2; # Leave fullscreen on new window
            disable_hyprland_logo = 1; # Disable hyprland wallpapers etc
            disable_splash_rendering = 1; # Disable startup splashscreen
            mouse_move_focuses_monitor = 0; # Disables hover for monitor focus
            focus_on_activate = 1; # Focuses windows which ask for activation
            enable_swallow = 1; # Enable window swalling
            swallow_regex = "^(foot)$"; # Make foot swallow executed windows
            swallow_exception_regex = "^(foot)$"; # Make foot not swallow itself
            initial_workspace_tracking = 0;
            vrr = 2;
            anr_missed_pings = 4; # by default, ANR dialog shows up way too aggressively.
            middle_click_paste = 0;
          };
          ecosystem = {
            no_update_news = 1;
            no_donation_nag = 1;
          };
          layerrule = [
            "blur, launcher"
            "blur, walker"
            "blur, wleave"
            "blur, bar-.*"
            "ignorezero, launcher"
            "ignorezero, bar-.*"
            "xray 1, wleave"
            "xray 1, bar-.*"
            "animation slide, notifications"
          ];
          decoration = {
            rounding = 0;

            shadow = {
              enabled = 0;
              color = "0xdd1a1a1a";
              render_power = 4;
              range = 8;
            };
            blur = {
              enabled = mkDefault 1;
              size = 4;
              passes = 3;
              popups = 1;
              brightness = 0.67;
            };
          };
          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];
          animation = [
            "windowsIn, 1, 3, easeOutQuint, slide"
            "windowsOut, 1, 3, easeOutQuint, slide"
            "windowsMove, 1, 3, easeOutQuint"

            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"

            "fadeIn, 1, 1.2, almostLinear"
            "fadeOut, 1, 2, almostLinear"
            "fadeSwitch, 1, 1.2, almostLinear"
            "fadeShadow, 1, 1.2, almostLinear"
            "fadeDim, 1, 1.2, almostLinear"
            "fadeLayers, 1, 1.4, linear"
            "fadePopups, 1, 2, linear"

            "border, 1, 5, easeOutQuint"
            "specialWorkspace, 1, 3, quick, fade"
            "zoomFactor, 1, 4, quick"

            # wsAnim will be vertical if multi-monitor, otherwise the animation will be weird
            # and it will look like windows are moving into each other across the monitors.
            "workspaces, 1, 4, easeOutQuint, ${wsAnim}"

            # don't zoom in when hyprland starts
            "monitorAdded, 0"
          ];

          animations.enabled = mkDefault 1;

          dwindle = {
            pseudotile = 1;
            preserve_split = 1;
          };
          windowrule = [
            # pause hypridle for certain apps
            "idleinhibit focus, class:^(mpv)$"
            "idleinhibit focus, class:^(atril)$"
            "idleinhibit fullscreen, class:^(foot)$"
            "idleinhibit fullscreen, class:^(steam_app_.*)$"

            # some apps, mostly games, are stupid and they fullscreen on the
            # wrong monitor. so just don't listen to them lol
            "suppressevent fullscreenoutput, class:.*"

            # Ignore maximize requests from apps. You'll probably like this.
            "suppressevent maximize, class:.*"

            # Fix some dragging issues with XWayland
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

            # dialogs
            "float,title:^(File Operation Progress)(.*)$"
            "float,title:^(Confirm to replace files)(.*)$"
            "float,title:^(Open File)(.*)$"
            "float,title:^(Select a File)(.*)$"
            "float,title:^(Choose wallpaper)(.*)$"
            "float,title:^(Open Folder)(.*)$"
            "float,title:^(Save As)(.*)$"
            "float,title:^(Rename)(.*)$"
            "float,title:^(Library)(.*)$"
            "float,class:^(org.gnome.FileRoller)$,title:^(Extract)(.*)$"

            # Window rules for games
            # Fix focus issues with cs2
            "suppressevent maximize fullscreen, class: ^(cs2)$"
            # make cs2 launch in fullscreen
            "fullscreen, class:^(cs2)$"
            # make tomb raider (2013) launch in fullscreen
            "fullscreen, class:^(steam_app_203160)$"

            # Sets fullscreen for common Minecraft windows
            "fullscreen, class:^(Minecraft\*.*)$"
            "fullscreen, initialTitle:^(Minecraft\*.*)$" # sometimes class isn't set
            "fullscreen, class:^(org-prismlauncher-EntryPoint)$"

            # Allow games to tear
            "immediate, class:^(steam_app_.*)$" # all steam games
            "immediate, class:^(cs2)$" # cs2
            "immediate, class:^(Minecraft\*.*)$"
            "immediate, initialTitle:^(Minecraft\*.*)$" # sometimes class isn't set
            "immediate, class:^(org-prismlauncher-EntryPoint)$" # legacy mc versions
            "immediate, class:^(osu!)$"
            "immediate, class:^(.*.exe)$" # all exe's
            "immediate, class:^(hl2_linux)$" # half life 2
            "immediate, class:^(cstrike_linux64)$" # cs source
            "immediate, class:^(gamescope)$"
            "immediate, class:^(Celeste)$"
            "immediate, class:^(info.cemu.Cemu)$"
            "immediate, class:^(Cuphead.x86_64)$"
            "immediate, class:^(org.eden_emu.eden)$"

            # Disable vrr for these apps / games, as I run them at higher than my rr
            "novrr, class:^(geometrydash.exe)$"
            "novrr, class:^(osu!)$"
          ];
          # NOTE: this sets workspaces to alternate if there are 2 monitors.
          workspace = optionalAttrs multiMonitor [
            "1, monitor:${cfg.defaultMonitor}"
            "2, monitor:${cfg.secondaryMonitor}"
            "3, monitor:${cfg.defaultMonitor}"
            "4, monitor:${cfg.secondaryMonitor}"
            "5, monitor:${cfg.defaultMonitor}"
            "6, monitor:${cfg.secondaryMonitor}"
            "7, monitor:${cfg.defaultMonitor}"
            "8, monitor:${cfg.secondaryMonitor}"
            "9, monitor:${cfg.defaultMonitor}"
            "10, monitor:${cfg.secondaryMonitor}"
          ];
          "$MOD" = "SUPER";
          bind =
            [
              # screenshot script
              ",Print, exec, ${getExe screenshotScript} --monitor ${cfg.defaultMonitor}"
              "SHIFT, Print, exec, ${getExe screenshotScript} --selection"
              "$MOD SHIFT, S, exec, ${getExe screenshotScript} --selection"
              "$MOD, Print, exec, ${getExe screenshotScript} --active"

              # binds for apps
              "$MOD, F, exec, thunar"
              "$MOD, T, exec, xdg-terminal-exec"
              "$MOD, B, exec, librewolf"
              "$MOD SHIFT, P, exec, librewolf --private-window"
              "$MOD, W, exec, Discord"
              "$MOD, D, exec, ${toggleProc "fuzzel"}"
              "$MOD SHIFT, E, exec, ${toggleProc pkgs.wleave} --protocol layer-shell -b 5 -T 360 -B 360 -k"
              "CTRL SHIFT, Escape, exec, xdg-terminal-exec btm"
              # extra schtuff
              "$MOD, N, exec, ${getExe sunsetScript} 3000"
              "$MOD, K, exec, ${toggleProc pkgs.hyprpicker} -r -a -n"
              "$MOD, R, exec, random-wall.sh"
              "$MOD SHIFT, R, exec, cycle-wall.sh"
              "$MOD, J, exec, xdg-terminal-exec wall-picker.sh"
              "$MOD, L, exec, loginctl lock-session"

              ", XF86AudioPrev, exec, ${getExe pkgs.mpc} prev; (pidof ncmpcpp || mpd-notif)"
              ", XF86AudioPlay, exec, ${getExe pkgs.mpc} toggle; mpd-notif"
              ", XF86AudioNext, exec, ${getExe pkgs.mpc} next; (pidof ncmpcpp || mpd-notif)"

              # passthrough binds for obs
              "Control_L, grave, pass, class:^(com.obsproject.Studio)$"
              "Control_L SHIFT, grave, pass, class:^(com.obsproject.Studio)$"

              # passthrough binds for discord
              # FIXME: doesn't even work
              # "Control_L SHIFT, M, pass, class:^(discord)$"

              # window management
              "$MOD, Q, killactive"
              "$MOD, Space, fullscreen"
              "$MOD, Tab, togglefloating"
              "$MOD, P, pseudo # dwindle"
              "$MOD, S, togglesplit # dwindle"

              # focus
              "$MOD, left, movefocus, l"
              "$MOD, right, movefocus, r"
              "$MOD, up, movefocus, u"
              "$MOD, down, movefocus, d"

              # move
              "$MOD SHIFT, left, movewindow, l"
              "$MOD SHIFT, right, movewindow, r"
              "$MOD SHIFT, up, movewindow, u"
              "$MOD SHIFT, down, movewindow, d"

              # navigate through workspaces on mouse
              "$MOD, mouse_down, workspace, e+1"
              "$MOD, mouse_up, workspace, e-1"
            ]
            ++ ( # workspaces
              # binds $MOD + [shift +] {1..10} to [move to] workspace {1..10}
              concatLists (genList (x: let
                  ws = let
                    c = (x + 1) / 10;
                  in
                    toString (x + 1 - (c * 10));
                in [
                  "$MOD, ${ws}, workspace, ${toString (x + 1)}"
                  "$MOD SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ])
                10)
            );

          binde = [
            # volume script
            ", XF86AudioRaiseVolume, exec, audio.sh vol up 5"
            ", XF86AudioLowerVolume, exec, audio.sh vol down 5"
            ", XF86AudioMute, exec, audio.sh vol toggle"
            ", XF86AudioMicMute, exec, audio.sh mic toggle"
            ", F20, exec, audio.sh mic toggle"

            # brightness script
            ", XF86MonBrightnessUp, exec, ${brightnessScript} up 5"
            ", XF86MonBrightnessDown, exec, ${brightnessScript} down 5"

            # can't type £ with US layout, so use wtype
            "$MOD, comma, exec, ${getExe pkgs.wtype} £"

            # resize
            "$MOD CTRL, left, resizeactive, -10 0"
            "$MOD CTRL, right, resizeactive, 10 0"
            "$MOD CTRL, up, resizeactive, 0 -10"
            "$MOD CTRL, down, resizeactive, 0 10"
          ];

          # mouse bindings
          bindm = [
            "$MOD, mouse:272, movewindow" # left click
            "$MOD, mouse:273, resizewindow" # right click
          ];

          # use when bug reporting
          debug = {
            # disable_logs = 0;
            # watchdog_timeout = 0;
          };
        };
      };
    };
  };
}
