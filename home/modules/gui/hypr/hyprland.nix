{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  multiMonitor =
    if config.gui.hypr.secondaryMonitor != null
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
in {
  options.gui.hypr.hyprland.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables hyprland and its configuration.";
  };
  options.gui.hypr.defaultMonitor = lib.mkOption {
    type = lib.types.str;
    default = "DP-3";
    description = "Sets the default monitor for many configs stemming from Hyprland.";
  };
  options.gui.hypr.secondaryMonitor = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Sets the default monitor for many configs stemming from Hyprland.";
  };

  config = lib.mkIf config.gui.hypr.hyprland.enable {
    home.packages = with pkgs; [
      # deps for hyprpm, might be able to remove later?
      cmake
      meson
      cpio
      pkg-config
    ];

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "hyprland";
      configPackages = [
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      ];
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    };

    home.pointerCursor = {
      hyprcursor.enable = true;
      hyprcursor.size = 24;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.variables = ["--all"];
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      systemd.enable = true;
      settings = {
        exec-once = [
          "sleep 0.5; random-wall.sh"
          "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1"
        ];
        exec = [
          "pgrep ags || ags"
          "${lib.getExe pkgs.xorg.xrandr} --output ${config.gui.hypr.defaultMonitor} --primary"
        ];
        monitor = [
          ", preferred, auto, auto"
          "desc:BOE, 1920x1080@60, 0x0, 1"
          "desc:GIGA-BYTE, 2560x1440@170,1920x0,1"
          "desc:Philips, 1920x1080@75,0x0,1"
        ];
        render = {
          direct_scanout = 0;
        };
        cursor = {
          default_monitor = "${config.gui.hypr.defaultMonitor}";
        };
        opengl = {
          nvidia_anti_flicker = 0;
        };
        plugin.xwaylandprimary = {
          display = "${config.gui.hypr.defaultMonitor}";
        };

        input = {
          repeat_rate = 55; # Set characters to repeat on hold every 55ms
          repeat_delay = 375; # Set repeat timeout to 375ms
          follow_mouse = 2; # Follow mouse clicks for window focus
          accel_profile = "flat";
          float_switch_override_focus = 0; # Stop floating windows from stealing focus
          # i hate caps lock, so make it escape instead.
          kb_options = "fkeys:basic_13-24 caps:escape";
          tablet = {
            left_handed = 1;
            output = "${config.gui.hypr.defaultMonitor}";
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
          border_size = 3; # Set window border width
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
          disable_hyprland_qtutils_check = 1;
        };
        source = ["~/.cache/wallust/colors_hyprland.conf"];
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
            render_power = 4;
            range = 8;
          };
          blur = {
            enabled = 1;
            size = 3;
            passes = 3;
            popups = 1;
            brightness = 0.7;
          };
        };
        animations = {
          enabled = 0; # Enable animations

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
            "workspaces, 1, 5, default, ${wsAnim}"
          ];
        };
        dwindle = {
          pseudotile = 1;
          preserve_split = 1;
        };
        windowrule = [
          "float, file_progress"
          "float, confirm"
          "float, dialog"
          "float, download"
          "float, notification"
          "float, error"
          "float, splash"
          "float, confirmreset"
          "float, title:Open File"
          "float, title:branchdialog"
        ];
        windowrulev2 = [
          # pause hypridle for certain apps
          "idleinhibit focus, class:^(mpv)$"
          "idleinhibit focus, class:^(atril)$"
          "idleinhibit fullscreen, class:^(.*)$"

          # Window rules for games
          # Fix focus issues with cs2
          "suppressevent maximize fullscreen, class: ^(SDL Application)$"

          # Set fullscreen for all steam games
          # "fullscreen, class:^(steam_app_.*)$"
          # "float, class:^(SDL Application)$";

          # Sets fullscreen for common Minecraft windows
          "fullscreen, class:^(Minecraft.*)$"
          "fullscreen, initialTitle:^(Minecraft.*)$"
          "fullscreen, class:^(org-prismlauncher-EntryPoint)$"

          # Allow games to tear
          "immediate, class:^(steam_app_.*)$"
          "immediate, class:^(SDL Application)$"
          "immediate, class:^(Minecraft.*)$"
          "immediate, initialTitle:^(Minecraft.*)$"
          "immediate, class:^(org-prismlauncher-EntryPoint)$"
          "immediate, class:^(osu!)$"
          "immediate, class: ^(.*.exe)$"
          "immediate, class: ^(hl2_linux)$"
          "immediate, class: ^(gamescope)$"
          "immediate, class: ^(Celeste)$"
          "immediate, class: ^(info.cemu.Cemu)$"

          # Fix everest (celeste) splash screen
          "float, class:^(EverestSplash-linux)$"

          # Make bakkesmod float, and only main rocket league window fullscreen
          "fullscreen, class:^(steam_app_252950)$, title:^(Rocket League (64-bit, DX11, Cooked))$"

          # Make Rocket League fill both monitors for split screen
          # "minsize 3840 1080, class: ^(steam_app_252950)$"
          # "maxsize 3840 1080, class: ^(steam_app_252950)$"
        ];
        workspace = lib.mkIf multiMonitor [
          "1, monitor:${config.gui.hypr.defaultMonitor}"
          "2, monitor:${config.gui.hypr.secondaryMonitor}"
          "3, monitor:${config.gui.hypr.defaultMonitor}"
          "4, monitor:${config.gui.hypr.secondaryMonitor}"
          "5, monitor:${config.gui.hypr.defaultMonitor}"
          "6, monitor:${config.gui.hypr.secondaryMonitor}"
          "7, monitor:${config.gui.hypr.defaultMonitor}"
          "8, monitor:${config.gui.hypr.secondaryMonitor}"
          "9, monitor:${config.gui.hypr.defaultMonitor}"
          "10, monitor:${config.gui.hypr.secondaryMonitor}"
        ];
        "$MOD" = "SUPER";
        bind =
          [
            # screenshot script
            ",Print, exec, screenshot.sh --monitor ${config.gui.hypr.defaultMonitor}"
            "SHIFT, Print, exec, screenshot.sh --selection"
            "$MOD, Print, exec, screenshot.sh --active"

            # binds for apps
            "$MOD, F, exec, thunar"
            "$MOD, T, exec, ${lib.getExe pkgs.foot}"
            "$MOD, B, exec, ${lib.getExe pkgs.librewolf}"
            "$MOD SHIFT, P, exec, ${lib.getExe pkgs.librewolf} --private-window"
            "$MOD, W, exec, ${lib.getExe pkgs.vesktop}"
            "$MOD, D, exec, pkill fuzzel || ${lib.getExe pkgs.fuzzel}"
            "$MOD SHIFT, E, exec, pkill wleave || ${lib.getExe pkgs.wleave} --protocol layer-shell -b 5 -T 360 -B 360"
            "CTRL SHIFT, Escape, exec, ${lib.getExe pkgs.foot} btm"

            # extra schtuff
            "$MOD, N, exec, pkill hyprsunset || ${lib.getExe pkgs.hyprsunset} -t 2000"
            "$MOD, R, exec, random-wall.sh"
            "$MOD SHIFT, R, exec, cycle-wall.sh"
            "$MOD, J, exec, ${lib.getExe pkgs.foot} wall-picker.sh"
            "$MOD, L, exec, ${lib.getExe' pkgs.systemd "loginctl"} lock-session"
            ", XF86AudioPrev, exec, ${lib.getExe pkgs.mpc} prev; (pidof ncmpcpp || mpd-notif.sh)"
            ", XF86AudioPlay, exec, ${lib.getExe pkgs.mpc} toggle; (mpd-notif.sh)"
            ", XF86AudioNext, exec, ${lib.getExe pkgs.mpc} next; (pidof ncmpcpp || mpd-notif.sh)"

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
          ", XF86AudioRaiseVolume, exec, audio.sh vol up 5"
          ", XF86AudioLowerVolume, exec, audio.sh vol down 5"
          ", XF86AudioMute, exec, audio.sh vol toggle"
          ", XF86AudioMicMute, exec, audio.sh mic toggle"

          # brightness script
          ", XF86MonBrightnessUp, exec, ${brightnessScript} up 5"
          ", XF86MonBrightnessDown, exec, ${brightnessScript} down 5"

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
        # debug = {
        #   disable_logs = 0;
        #   watchdog_timeout = 0;
        # };
      };
      extraConfig = ''
        # submaps
        # Disables all keybinds for moonlight or vm's
        bind = $MOD SHIFT, N, submap, clean
        submap = clean
        bind = $MOD SHIFT, N, submap, reset
        submap = reset
      '';
    };
  };
  imports = [./env.nix];
}
