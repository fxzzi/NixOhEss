{
  lib,
  pkgs,
  config,
  osConfig,
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
    if osConfig.cfg.wayland.hyprland.useGit
    then inputs.hyprsunset.packages.${pkgs.stdenv.hostPlatform.system}
    else pkgs;
  runProc = pkg: "app2unit -- ${pkg}";
  runTerm = cmd: "app2unit -T ${cmd}";
  toggleProc = pkg: "pkill ${builtins.baseNameOf (lib.getExe pkg)} || ${runProc "${lib.getExe pkg}"}";
  uwsm = lib.getExe' osConfig.programs.uwsm.package "uwsm";
in {
  options.cfg.gui = {
    hypr = {
      hyprland = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = osConfig.wayland.hyprland.enable;
          defaultText = "osConfig.wayland.hyprland.enable";
          description = "Enables hyprland and its configuration.";
        };
        autoStart = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enables hyprland to run automatically in tty1 (zsh)";
        };
      };
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
    };
  };

  config = lib.mkIf config.cfg.gui.hypr.hyprland.enable {
    programs.zsh.profileExtra = lib.mkIf config.cfg.gui.hypr.hyprland.autoStart ''
      if ${uwsm} check may-start; then
       exec ${uwsm} start hyprland-uwsm.desktop
      fi
    '';

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      systemd.variables = ["--all"];
      # use the package and portalPackage defined in the nixos hyprland module
      package = null;
      portalPackage = null;
      settings = {
        exec-once = [
          "sleep 0.5; ${runProc "random-wall.sh"}" # HACK: sleep here, otherwise wallpaper will be set too early
          "${runProc "${pkgs.mate.mate-polkit}/etc/xdg/autostart/polkit-mate-authentication-agent-1.desktop"}"
        ];
        exec = [
          "pgrep ${builtins.baseNameOf (lib.getExe config.programs.ags.finalPackage)} || (sleep 0.5; ${runProc "${lib.getExe config.programs.ags.finalPackage}"})"
          "${runProc "${lib.getExe pkgs.xorg.xrandr} --output ${config.cfg.gui.hypr.defaultMonitor} --primary"}"
        ];
        monitor = [
          ", preferred, auto, 1" # set 1x scale for all monitors which are undefined here. should be a good default.
          "desc:Lenovo, 1920x1080@60, 0x0, 1"
          "desc:GIGA-BYTE, 2560x1440@170,1920x0, 1"
          # calculate offset by doing (1440-1080)/2
          "desc:Philips, 1920x1080@75,0x180, 1"
        ];
        render = {
          direct_scanout = 1;
        };
        cursor = lib.mkIf multiMonitor {
          default_monitor = "${config.cfg.gui.hypr.defaultMonitor}";
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
          # i hate caps lock, so make it escape instead.
          kb_options = "fkeys:basic_13-24, caps:escape";
          # don't set tablet settings if opentabletdriver is enabled.
          tablet = lib.mkIf (! osConfig.cfg.opentabletdriver.enable) {
            left_handed = 1; # inverted tablet
            output = "${config.cfg.gui.hypr.defaultMonitor}";
          };
          touchpad = {
            natural_scroll = true;
          };
        };
        device = [
          {
            name = "tpps/2-elan-trackpoint";
            accel_profile = "flat";
          }
          {
            name = "at-translated-set-2-keyboard";
            kb_layout = "gb";
          }
          {
            name = "elan0680:00-04f3:320a-touchpad";
            accel_profile = "adaptive";
          }
        ];
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
          vrr = 2; # vrr = 1 is cooked on nvidia rn
        };
        decoration = {
          rounding = 0;
          layerrule = [
            "blur, launcher"
            "blur, wleave"
            "blur, bar-.*"
            "ignorezero, launcher"
            "ignorezero, bar-.*"
            "xray 1, wleave"
            "xray 1, bar-.*"
          ];
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
        animations = {
          enabled = 0;

          bezier = [
            "overshot, 0.05, 0.9, 0.1, 1.05"
            "smoothOut, 0.36, 0, 0.66, -0.56"
            "smoothIn, 0.25, 1, 0.5, 1"
          ];
          animation = [
            "windows, 1, 4, overshot, slide"
            "windowsMove, 1, 3, default"
            "border, 1, 8, default"
            "fade, 1, 3, smoothIn"
            "fadeDim, 1, 3, smoothOut"
            # wsAnim will be vertical if multi-monitor, otherwise the animation will be weird
            # and it will look like windows are moving into each other across the monitors.
            "workspaces, 1, 5, default, ${wsAnim}"
          ];
        };
        dwindle = {
          pseudotile = 1;
          preserve_split = 1;
        };
        windowrule = [
          # pause hypridle for certain apps
          "idleinhibit focus, class:^(mpv)$"
          "idleinhibit focus, class:^(atril)$"

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

          # Fix everest (celeste) splash screen
          "float, class:^(EverestSplash-linux)$"

          # Make Rocket League fill both monitors for split screen
          # "minsize 3840 1080, class: ^(steam_app_252950)$"
          # "maxsize 3840 1080, class: ^(steam_app_252950)$"
        ];
        # NOTE: this sets workspaces to alternate if there are 2 monitors.
        workspace = lib.mkIf multiMonitor [
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
            ",Print, exec, ${runProc "screenshot.sh --monitor ${config.cfg.gui.hypr.defaultMonitor}"}"
            "SHIFT, Print, exec, ${runProc "screenshot.sh --selection"}"
            "$MOD, Print, exec, ${runProc "screenshot.sh --active"}"

            # binds for apps, using uwsm-app
            "$MOD, F, exec, ${runProc "thunar.desktop"}"
            "$MOD, T, exec, ${runProc "foot.desktop"}"
            "$MOD, B, exec, ${runProc "librewolf.desktop"}"
            "$MOD SHIFT, P, exec, ${runProc "librewolf.desktop:new-private-window"}"
            "$MOD, W, exec, ${runProc "vesktop.desktop"}"
            "$MOD, D, exec, ${toggleProc config.programs.fuzzel.package}"
            "$MOD SHIFT, E, exec, ${toggleProc config.programs.wlogout.package} --protocol layer-shell -b 5 -T 360 -B 360 -k"
            "CTRL SHIFT, Escape, exec, ${runTerm "btm"}"

            # extra schtuff
            "$MOD, N, exec, ${toggleProc hyprsunsetPkg.hyprsunset} -t 2000"
            "$MOD, R, exec, ${runProc "random-wall.sh"}"
            "$MOD SHIFT, R, exec, ${runProc "cycle-wall.sh"}"
            "$MOD, J, exec, ${runTerm "wall-picker.sh"}"
            "$MOD, L, exec, ${runProc "${lib.getExe' pkgs.systemd "loginctl"} lock-session"}"
            ", XF86AudioPrev, exec, ${runProc "${lib.getExe pkgs.mpc} prev; (pidof ncmpcpp || mpd-notif.sh)"}"
            ", XF86AudioPlay, exec, ${runProc "${lib.getExe pkgs.mpc} toggle"}"
            ", XF86AudioNext, exec, ${runProc "${lib.getExe pkgs.mpc} next; (pidof ncmpcpp || mpd-notif.sh)"}"

            # passthrough binds for obs
            "Alt, M, pass,^(com.obsproject.Studio)$"
            "Alt, N, pass,^(com.obsproject.Studio)$"

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
          "$MOD, mouse:272, movewindow"
          "$MOD, mouse:273, resizewindow"
        ];

        # use when bug reporting
        # env = [
        # 	"AQ_TRACE" = "1"
        # 	"HYPRLAND_TRACE" = "1"
        # ];
        debug = {
          disable_logs = 0;
          # watchdog_timeout = 0;
        };
      };
      extraConfig = ''
        # submaps
        # disables all keybinds for moonlight or vm's
        bind = $MOD SHIFT, N, submap, clean
        submap = clean
        bind = $MOD SHIFT, N, submap, reset
        submap = reset
      '';
    };
  };
  imports = [./env.nix];
}
