{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  multiMonitor =
    if config.cfg.gui.hypr.secondaryMonitor != null
    then true
    else false;
  brightnessScript =
    if multiMonitor
    then "brightness.sh"
    else "brightness-laptop.sh";
  wsAnim =
    if multiMonitor
    then "slidevert"
    else "slide";
  hyprsunsetPkg =
    if config.cfg.gui.hypr.useGit
    then inputs.hyprsunset.packages.${pkgs.stdenv.hostPlatform.system}
    else pkgs;
  uwsmEnabled = config.cfg.wayland.uwsm.enable;
  runProc = pkg:
    if uwsmEnabled
    then "app2unit -- ${pkg}"
    else "${pkg}";
  runTerm = cmd:
    if uwsmEnabled
    then "app2unit -T ${cmd}"
    else "${cmd}";
  toggleProc = pkg: let
    exe =
      if builtins.isString pkg
      then pkg
      else lib.getExe pkg;
    binaryName =
      if builtins.isString pkg
      then exe
      else builtins.baseNameOf exe;
  in
    if uwsmEnabled
    then "pkill ${binaryName} || ${runProc exe}"
    else "pkill ${binaryName} || ${exe}";
  runOnce = pkg: let
    exe = lib.getExe pkg;
  in
    if uwsmEnabled
    then "pgrep ${builtins.baseNameOf exe} || ${runProc exe}"
    else "pgrep ${builtins.baseNameOf exe} || ${exe}";

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
        $grimCmd -g "$(slurp)" "$path"
        kill $PID
        ;;
      --active)
        window_geometry=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')

        $grimCmd -g "$window_geometry" "$path"
        ;;
      esac

      # if the screenshot was not cancelled
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
  options.cfg.gui = {
    hypr = {
      defaultMonitor = lib.mkOption {
        type = lib.types.str;
        default = "DP-1";
        description = "Sets the default monitor for hypr*";
      };
      secondaryMonitor = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Sets the secondary monitor for hypr*.";
      };
      animations.enable = lib.mkEnableOption "animations";
    };
  };
  config = {
    hj = {
      packages = [
        screenshotScript
      ];
    };
    programs.hyprland = {
      settings = {
        exec-once = [
          "${runProc "${pkgs.mate.mate-polkit}/etc/xdg/autostart/polkit-mate-authentication-agent-1.desktop"}"
        ];
        exec = [
          "${runOnce inputs.ags.packages.${pkgs.system}.default}"
          "${runProc "${lib.getExe pkgs.xorg.xrandr} --output ${config.cfg.gui.hypr.defaultMonitor} --primary"}"
        ];
        monitor = [
          ", preferred, auto, 1" # set 1x scale for all monitors which are undefined here. should be a good default.
          "desc:Lenovo, 1920x1080@60, 0x0, 1"
          "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 20120B000001, 2560x1440@170,1920x0, 1"
          "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 23080B004543, 2560x1440@170,0x0, 1" # kunzoz's monitor
          # calculate offset by doing (1440-1080)/2
          "desc:Philips, 1920x1080@75,0x180, 1"
        ];
        render = {
          direct_scanout = 1;
          cm_enabled = 0; # fix weird transparency in foot
        };
        cursor = {
          default_monitor = lib.mkIf multiMonitor "${config.cfg.gui.hypr.defaultMonitor}";
          sync_gsettings_theme = 0;
          enable_hyprcursor = 0;
        };
        opengl = {
          nvidia_anti_flicker = 0;
        };
        input = {
          repeat_rate = 55; # Set characters to repeat on hold every 55ms
          repeat_delay = 375; # Set repeat timeout to 375ms
          follow_mouse = 2; # Follow mouse clicks for window focus
          accel_profile = "flat";
          float_switch_override_focus = 0; # Stop floating windows from stealing focus
          # i hate caps lock, so make it escape instead. also reset f13-f24 to their expected keysyms.
          kb_options = "fkeys:basic_13-24, caps:escape";
          # don't set tablet settings if opentabletdriver is enabled.
          tablet = lib.optionalAttrs (!config.cfg.opentabletdriver.enable) {
            left_handed = 1; # inverted tablet
            output = "${config.cfg.gui.hypr.defaultMonitor}";
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
          allow_tearing = 1;
        };
        misc = {
          new_window_takes_over_fullscreen = 2; # Leave fullscreen on new window
          disable_hyprland_logo = 1; # Disable hyprland wallpapers etc
          disable_splash_rendering = 1; # Disable startup splashscreen
          mouse_move_focuses_monitor = 0; # Disables hover for monitor focus
          focus_on_activate = 1; # Focuses windows which ask for activation
          enable_swallow = 0; # Enable window swalling
          swallow_regex = "^(foot)$"; # Make foot swallow executed windows
          initial_workspace_tracking = 0;
          vrr = 2; # avoid flickering with vrr = 1
          anr_missed_pings = 2; # by default, ANR dialog shows up way too aggressively.
          middle_click_paste = 0;
        };
        layerrule = [
          "blur, launcher"
          "blur, walker"
          "blur, wleave"
          "blur, bar-.*"
          "ignorezero, launcher"
          "ignorezero, walker"
          "ignorezero, bar-.*"
          "xray 1, wleave"
          "xray 1, bar-.*"
        ];
        decoration = {
          rounding = 0;

          shadow = {
            enabled = 0;
            color = "0xee1a1a1a";
            render_power = 3;
            range = 6;
          };
          blur = {
            enabled = 1;
            size = 4;
            passes = 3;
            popups = 1;
            brightness = 0.67;
          };
        };
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "smoothIn, 0.25, 1, 0.5, 1"
        ];
        animation = [
          "windows, 1, 4, overshot"
          "windowsMove, 1, 3, default"
          "border, 1, 8, default"
          "fade, 1, 3, smoothIn"
          "fadeDim, 1, 3, smoothOut"
          # wsAnim will be vertical if multi-monitor, otherwise the animation will be weird
          # and it will look like windows are moving into each other across the monitors.
          "workspaces, 1, 5, default, ${wsAnim}"
        ];
        animations = {
          enabled = config.cfg.gui.hypr.animations.enable;
        };
        dwindle = {
          pseudotile = 1;
          preserve_split = 1;
        };
        windowrule = [
          # pause hypridle for certain apps
          "idleinhibit focus, class:^(mpv)$"
          "idleinhibit focus, class:^(atril)$"
          "idleinhibit fullscreen, class:^(foot)$"

          # some apps, mostly games, are stupid and they fullscreen on the
          # wrong monitor. so just don't listen to them lol
          "suppressevent fullscreenoutput, class:.*"

          # Ignore maximize requests from apps. You'll probably like this.
          "suppressevent maximize, class:.*"

          # Fix some dragging issues with XWayland
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

          # Window rules for games
          # Fix focus issues with cs2
          "suppressevent maximize fullscreen, class: ^(SDL Application)$"
          "suppressevent maximize fullscreen, class: ^(cs2)$"

          # Sets fullscreen for common Minecraft windows
          "fullscreen, class:^(Minecraft.*)$"
          "fullscreen, initialTitle:^(Minecraft.*)$"
          "fullscreen, class:^(org-prismlauncher-EntryPoint)$"

          # Allow games to tear
          "immediate, class:^(steam_app_.*)$" # all steam games
          "immediate, class:^(SDL Application)$" # cs2 native wayland
          "immediate, class:^(cs2)$" # cs2
          "immediate, class:^(Minecraft.*)$" # modern minecraft
          "immediate, initialTitle:^(Minecraft.*)$" # 1.8.9 for some reason
          "immediate, class:^(org-prismlauncher-EntryPoint)$" # legacy mc versions
          "immediate, class:^(osu!)$"
          "immediate, class: ^(.*.exe)$" # all exe's
          "immediate, class: ^(hl2_linux)$" # half life 2
          "immediate, class: ^(cstrike_linux64)$" # cs source
          "immediate, class: ^(gamescope)$"
          "immediate, class: ^(Celeste)$"
          "immediate, class: ^(info.cemu.Cemu)$"
          "immediate, class: ^(Cuphead.x86_64)$"

          # Fix everest (celeste) splash screen
          "float, class:^(EverestSplash-linux)$"

          # Make Rocket League fill both monitors for split screen
          # "minsize 3840 1080, class: ^(steam_app_252950)$"
          # "maxsize 3840 1080, class: ^(steam_app_252950)$"
        ];
        # NOTE: this sets workspaces to alternate if there are 2 monitors.
        workspace = lib.optionalAttrs multiMonitor [
          "1, monitor:${config.cfg.gui.hypr.defaultMonitor}"
          "2, monitor:${config.cfg.gui.hypr.secondaryMonitor}"
          "3, monitor:${config.cfg.gui.hypr.defaultMonitor}"
          "4, monitor:${config.cfg.gui.hypr.secondaryMonitor}"
          "5, monitor:${config.cfg.gui.hypr.defaultMonitor}"
          "6, monitor:${config.cfg.gui.hypr.secondaryMonitor}"
          "7, monitor:${config.cfg.gui.hypr.defaultMonitor}"
          "8, monitor:${config.cfg.gui.hypr.secondaryMonitor}"
          "9, monitor:${config.cfg.gui.hypr.defaultMonitor}"
          "10, monitor:${config.cfg.gui.hypr.secondaryMonitor}"
        ];
        "$MOD" = "SUPER";
        bind =
          [
            # screenshot script
            ",Print, exec, ${runProc "${lib.getExe screenshotScript} --monitor ${config.cfg.gui.hypr.defaultMonitor}"}"
            "SHIFT, Print, exec, ${runProc "${lib.getExe screenshotScript} --selection"}"
            "$MOD SHIFT, S, exec, ${runProc "${lib.getExe screenshotScript} --selection"}"
            "$MOD, Print, exec, ${runProc "${lib.getExe screenshotScript} --active"}"

            # binds for apps
            "$MOD, F, exec, ${runProc "thunar.desktop"}"
            "$MOD, T, exec, ${runProc "foot.desktop"}"
            "$MOD, B, exec, ${runProc "librewolf.desktop"}"
            "$MOD SHIFT, P, exec, ${runProc "librewolf.desktop:new-private-window"}"
            "$MOD, W, exec, ${runProc "vesktop.desktop"}"
            "$MOD, D, exec, ${toggleProc "fuzzel"}"
            "$MOD SHIFT, E, exec, ${toggleProc pkgs.wleave} --protocol layer-shell -b 5 -T 360 -B 360 -k"
            "CTRL SHIFT, Escape, exec, ${runTerm "btm"}"

            # extra schtuff
            "$MOD, N, exec, ${toggleProc hyprsunsetPkg.hyprsunset} -t 2000"
            "$MOD, R, exec, ${runProc "random-wall.sh"}"
            "$MOD SHIFT, R, exec, ${runProc "cycle-wall.sh"}"
            "$MOD, J, exec, ${runTerm "wall-picker.sh"}"
            "$MOD, L, exec, ${runProc "${lib.getExe' pkgs.systemd "loginctl"} lock-session"}"
            ", XF86AudioPrev, exec, ${runProc "${lib.getExe pkgs.mpc} prev; (pidof ncmpcpp || mpd-notif)"}"
            ", XF86AudioPlay, exec, ${runProc "${lib.getExe pkgs.mpc} toggle; mpd-notif"}"
            ", XF86AudioNext, exec, ${runProc "${lib.getExe pkgs.mpc} next; (pidof ncmpcpp || mpd-notif)"}"

            # passthrough binds for obs
            "Control_L, grave, pass, class:^(com.obsproject.Studio)$"
            "Control_L SHIFT, grave, pass, class:^(com.obsproject.Studio)$"

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
          ++ (
            # workspaces
            # binds $MOD + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (
              builtins.genList (
                i: let
                  ws = i + 1;
                in [
                  "$MOD, code:1${toString i}, workspace, ${toString ws}"
                  "$MOD SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              )
              9
            )
          );

        binde = [
          # volume script
          ", XF86AudioRaiseVolume, exec, ${runProc "audio.sh vol up 5"}"
          ", XF86AudioLowerVolume, exec, ${runProc "audio.sh vol down 5"}"
          ", XF86AudioMute, exec, ${runProc "audio.sh vol toggle"}"
          ", XF86AudioMicMute, exec, ${runProc "audio.sh mic toggle"}"
          ", F20, exec, ${runProc "audio.sh mic toggle"}"

          # brightness script
          ", XF86MonBrightnessUp, exec, ${runProc "${brightnessScript} up 5"}"
          ", XF86MonBrightnessDown, exec, ${runProc "${brightnessScript} down 5"}"

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
          disable_logs = 0;
          # watchdog_timeout = 0;
        };
      };
    };
  };
}
