{ lib, inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    systemd.enable = true;
    extraConfig = ''
      # █▀▀ ▀▄▀ █▀▀ █▀▀
      # ██▄ █░█ ██▄ █▄▄
      exec-once		= random-wall.sh
      exec-once		= gsettings.sh # Applies gtk themes, cursor themes, etc
      exec-once		= ${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1 
      # exec-once		= hyprpm reload -nn
      exec				= pidof ags || ${lib.getExe pkgs.ags}
      exec				= ${lib.getExe pkgs.xorg.xrandr} --output DP-3 --primary

      # █▀▄▀█ █▀█ █▄░█ █ ▀█▀ █▀█ █▀█
      # █░▀░█ █▄█ █░▀█ █ ░█░ █▄█ █▀▄
      monitor = desc:GIGA-BYTE, 2560x1440@170,1920x0,1
      monitor = desc:Philips, 1920x1080@75,0x0,1

      # █▀█ █▀▀ █▄░█ █▀▄ █▀▀ █▀█ █ █▄░█ █▀▀
      # █▀▄ ██▄ █░▀█ █▄▀ ██▄ █▀▄ █ █░▀█ █▄█
      render {
      	# direct_scanout = 1
      }

      cursor {
      	default_monitor = DP-3
      	no_hardware_cursors = 0
      	use_cpu_buffer = 1
      }

      opengl {
      	nvidia_anti_flicker = 0
      }

      plugin {
          xwaylandprimary {
              display = DP-3
          }
      }

      # █ █▄░█ █▀█ █░█ ▀█▀
      # █ █░▀█ █▀▀ █▄█ ░█░
      input {
        repeat_rate = 55 # Set characters to repeat on hold every 55ms
        repeat_delay = 375 # Set repeat timeout to 375ms
        follow_mouse = 2 # Follow mouse clicks for window focus
      	force_no_accel = 1
        float_switch_override_focus = 0 # Stop floating windows from stealing focus
      	kb_options = fkeys:basic_13-24
      	tablet {
      		left_handed = 1
      		output = DP-3
      	}
      }

      # █▀▀ █▀▀ █▄░█ █▀▀ █▀█ ▄▀█ █░░
      # █▄█ ██▄ █░▀█ ██▄ █▀▄ █▀█ █▄▄
      general {
        gaps_out = 4 # Outer monitor gaps
        gaps_in = 2 # Inner window gaps
        border_size = 3 # Set window border width
      	allow_tearing = 1
      }

      # █▀▄▀█ █ █▀ █▀▀
      # █░▀░█ █ ▄█ █▄▄
      misc {
        new_window_takes_over_fullscreen = 2 # Leave fullscreen on new window
        disable_hyprland_logo = 1 # Disable logo on
        disable_splash_rendering = 1 # Disable startup splashscreen
        mouse_move_focuses_monitor = 0 # Disables hover for monitor focus
        focus_on_activate = 1 # Focuses windows which ask for activation
        enable_swallow = 1 # Enable window swalling
        swallow_regex = ^(foot)$ # Make foot swallow executed windows
        initial_workspace_tracking = 0
      	disable_hyprland_qtutils_check = 1
      }

      # █▀▄ █▀▀ █▀▀ █▀█ █▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
      # █▄▀ ██▄ █▄▄ █▄█ █▀▄ █▀█ ░█░ █ █▄█ █░▀█
      # wallust colors
      source = ~/.cache/wallust/colors_hyprland.conf

      decoration {
          rounding = 0
          layerrule = blur, launcher
          layerrule = blur, wleave
      		layerrule = blur, bar-.*
          layerrule = ignorezero, launcher
      		layerrule = ignorezero, bar-.*
      		layerrule = xray 1, wleave
         layerrule = xray 1, bar-.*
      		shadow {
      			enabled = 0
      			color = 0xee1a1a1a
      			render_power = 4
      			range = 8
      		}
          blur {
      			enabled = 1
      			size = 3
      			passes = 3
      			popups = 1
      			brightness = 0.7
          }
      }

      # ▄▀█ █▄░█ █ █▀▄▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█ █▀
      # █▀█ █░▀█ █ █░▀░█ █▀█ ░█░ █ █▄█ █░▀█ ▄█
      animations {
          enabled = 0 # Enable animations

          bezier = overshot, 0.05, 0.9, 0.1, 1.05
          bezier = smoothOut, 0.36, 0, 0.66, -0.56
          bezier = smoothIn, 0.25, 1, 0.5, 1

          animation = windows, 1, 4, overshot, slide
          animation = windowsMove, 1, 3, default
          animation = border, 1, 8, default
          animation = fade, 1, 3, smoothIn
          animation = fadeDim, 1, 3, smoothOut
          animation = workspaces, 1, 5, default, slidevert
      }

      # █░░ ▄▀█ █▄█ █▀█ █░█ ▀█▀ █▀
      # █▄▄ █▀█ ░█░ █▄█ █▄█ ░█░ ▄█
      dwindle {
        pseudotile = 1 # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = 1 # you probably want this
      }

      # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
      # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█
      windowrule = float, file_progress
      windowrule = float, confirm
      windowrule = float, dialog
      windowrule = float, download
      windowrule = float, notification
      windowrule = float, error
      windowrule = float, splash
      windowrule = float, confirmreset
      windowrule = float, title:Open File
      windowrule = float, title:branchdialog

      # pause hypridle for certain apps
      windowrulev2 = idleinhibit focus, class:^(mpv)$
      windowrulev2 = idleinhibit focus, class:^(atril)$
      windowrulev2 = idleinhibit fullscreen, class:^(.*)$

      # Window rules for games
      # Fix focus issues with cs2
      windowrulev2 = suppressevent maximize fullscreen, class: ^(SDL Application)$

      # Set fullscreen for all steam games
      # windowrulev2 = fullscreen, class:^(steam_app_.*)$
      # windowrulev2 = float, class:^(SDL Application)$

      # Sets fullscreen for common Minecraft windows
      windowrulev2 = fullscreen, class:^(Minecraft.*)$
      windowrulev2 = fullscreen, initialTitle:^(Minecraft.*)$
      windowrulev2 = fullscreen, class:^(org-prismlauncher-EntryPoint)$

      # Allow games to tear
      windowrulev2 = immediate, class:^(steam_app_.*)$
      windowrulev2 = immediate, class:^(SDL Application)$
      windowrulev2 = immediate, class:^(Minecraft.*)$
      windowrulev2 = immediate, initialTitle:^(Minecraft.*)$
      windowrulev2 = immediate, class:^(org-prismlauncher-EntryPoint)$
      windowrulev2 = immediate, class:^(osu!)$
      windowrulev2 = immediate, class: ^(.*.exe)$
      windowrulev2 = immediate, class: ^(hl2_linux)$
      windowrulev2 = immediate, class: ^(gamescope)$
      windowrulev2 = immediate, class: ^(Celeste)$
      windowrulev2 = immediate, class: ^(info.cemu.Cemu)$

      # Fix everest (celeste) splash screen
      windowrulev2 = float, class:^(EverestSplash-linux)$

      # Make bakkesmod float, and only main rocket league window fullscreen
      windowrulev2 = fullscreen, class:^(steam_app_252950)$, title:^(Rocket League \(64-bit, DX11, Cooked\))$

      # Make Rocket League fill both monitors for split screen
      # windowrulev2 = minsize 3840 1080, class: ^(steam_app_252950)$
      # windowrulev2 = maxsize 3840 1080, class: ^(steam_app_252950)$

      # █░█░█ █▀█ █▀█ █▄▀ █▀ █▀█ ▄▀█ █▀▀ █▀▀ █▀
      # ▀▄▀▄▀ █▄█ █▀▄ █░█ ▄█ █▀▀ █▀█ █▄▄ ██▄ ▄█
      # Sets alternating workspaces for dual monitor setup
      # Main gets odd ws, secondary gets even ws
      workspace = 1, monitor:DP-3
      workspace = 2, monitor:DP-2
      workspace = 3, monitor:DP-3
      workspace = 4, monitor:DP-2
      workspace = 5, monitor:DP-3
      workspace = 6, monitor:DP-2
      workspace = 7, monitor:DP-3
      workspace = 8, monitor:DP-2
      workspace = 9, monitor:DP-3
      workspace = 10, monitor:DP-2

      # █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █▀
      # █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀ ▄█
      $MOD = SUPER

      # █▀ █▀▀ █▀█ █▀▀ █▀▀ █▄░█ █▀ █░█ █▀█ ▀█▀
      # ▄█ █▄▄ █▀▄ ██▄ ██▄ █░▀█ ▄█ █▀█ █▄█ ░█░
      bind = ,Print, exec, screenshot.sh --monitor
      bind = SHIFT, Print, exec, screenshot.sh --selection
      bind = $MOD, Print, exec, screenshot.sh --active

      # █░█ █▀█ █░░ █░█ █▀▄▀█ █▀▀
      # ▀▄▀ █▄█ █▄▄ █▄█ █░▀░█ ██▄
      binde=, XF86AudioRaiseVolume, exec, audio.sh vol up 5
      binde=, XF86AudioLowerVolume, exec, audio.sh vol down 5
      binde=, XF86AudioMute, exec, audio.sh vol toggle

      # █▄▄ █▀█ █ █▀▀ █░█ ▀█▀ █▄░█ █▀▀ █▀ █▀
      # █▄█ █▀▄ █ █▄█ █▀█ ░█░ █░▀█ ██▄ ▄█ ▄█
      binde=, XF86MonBrightnessUp, exec, brightness.sh up 5
      binde=, XF86MonBrightnessDown, exec, brightness.sh down 5

      # ▄▀█ █▀█ █▀█ █▀
      # █▀█ █▀▀ █▀▀ ▄█
      bind = $MOD, F, exec, ${lib.getExe pkgs.xfce.thunar}
      bind = $MOD, T, exec, ${lib.getExe pkgs.foot}
      bind = $MOD, B, exec, ${lib.getExe pkgs.librewolf}
      bind = $MOD SHIFT, P, exec, ${lib.getExe pkgs.librewolf} --private-window
      bind = $MOD, W, exec, ${lib.getExe pkgs.vesktop}
      bind = $MOD, D, exec, pkill fuzzel || ${lib.getExe pkgs.fuzzel}
      bind = $MOD SHIFT, E, exec, pkill wleave || ${lib.getExe pkgs.wleave} --protocol layer-shell -b 5 -T 360 -B 360

      bind = CTRL SHIFT, Escape, exec, ${lib.getExe pkgs.foot} btm

      # █▀▀ ▀▄▀ ▀█▀ █▀█ ▄▀█
      # ██▄ █░█ ░█░ █▀▄ █▀█
      bind = $MOD, N, exec, pkill hyprsunset || ${lib.getExe pkgs.hyprsunset} -t 2000
      bind = $MOD, R, exec, random-wall.sh
      bind = $MOD SHIFT, R, exec, cycle-wall.sh
      bind = $MOD, J, exec, ${lib.getExe pkgs.foot} wall_picker.sh
      bind = $MOD, L, exec, ${lib.getExe' pkgs.systemd "loginctl"} lock-session

      bind = , XF86AudioPrev, exec, ${lib.getExe pkgs.mpc} prev; (pidof ncmpcpp || mpd-notif.sh)
      bind = , XF86AudioPlay, exec, ${lib.getExe pkgs.mpc} toggle; (mpd-notif.sh)
      bind = , XF86AudioNext, exec, ${lib.getExe pkgs.mpc} next; (pidof ncmpcpp || mpd-notif.sh)

      # Global binds for OBS
      bind = Alt, M,			pass,^(com\.obsproject\.Studio)$
      bind = Alt, N,			pass,^(com\.obsproject\.Studio)$

      # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀▄▀█ ▄▀█ █▄░█ ▄▀█ █▀▀ █▀▄▀█ █▀▀ █▄░█ ▀█▀
      # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █░▀░█ █▀█ █░▀█ █▀█ █▄█ █░▀░█ ██▄ █░▀█ ░█░
      bind = $MOD, Q, killactive
      bind = $MOD, Space, fullscreen
      bind = $MOD, Tab, togglefloating
      bind = $MOD, P, pseudo # dwindle
      bind = $MOD, S, togglesplit # dwindle

      # █▀▀ █▀█ █▀▀ █░█ █▀
      # █▀░ █▄█ █▄▄ █▄█ ▄█
      bind = $MOD, left, movefocus, l
      bind = $MOD, right, movefocus, r
      bind = $MOD, up, movefocus, u
      bind = $MOD, down, movefocus, d

      # █▀▄▀█ █▀█ █░█ █▀▀
      # █░▀░█ █▄█ ▀▄▀ ██▄
      bind = $MOD SHIFT, left, movewindow, l
      bind = $MOD SHIFT, right, movewindow, r
      bind = $MOD SHIFT, up, movewindow, u
      bind = $MOD SHIFT, down, movewindow, d

      # █▀█ █▀▀ █▀ █ ▀█ █▀▀
      # █▀▄ ██▄ ▄█ █ █▄ ██▄
      binde = $MOD CTRL, left, resizeactive, -10 0
      binde = $MOD CTRL, right, resizeactive, 10 0
      binde = $MOD CTRL, up, resizeactive, 0 -10
      binde = $MOD CTRL, down, resizeactive, 0 10

      # █▀ █░█░█ █ ▀█▀ █▀▀ █░█
      # ▄█ ▀▄▀▄▀ █ ░█░ █▄▄ █▀█
      bind = $MOD, 1, workspace, 1
      bind = $MOD, 2, workspace, 2
      bind = $MOD, 3, workspace, 3
      bind = $MOD, 4, workspace, 4
      bind = $MOD, 5, workspace, 5
      bind = $MOD, 6, workspace, 6
      bind = $MOD, 7, workspace, 7
      bind = $MOD, 8, workspace, 8
      bind = $MOD, 9, workspace, 9
      bind = $MOD, 0, workspace, 10
      bind = $MOD ALT, up, workspace, e+1
      bind = $MOD ALT, down, workspace, e-1

      # █▀▄▀█ █▀█ █░█ █▀▀
      # █░▀░█ █▄█ ▀▄▀ ██▄
      bind = $MOD SHIFT, 1, movetoworkspace, 1
      bind = $MOD SHIFT, 2, movetoworkspace, 2
      bind = $MOD SHIFT, 3, movetoworkspace, 3
      bind = $MOD SHIFT, 4, movetoworkspace, 4
      bind = $MOD SHIFT, 5, movetoworkspace, 5
      bind = $MOD SHIFT, 6, movetoworkspace, 6
      bind = $MOD SHIFT, 7, movetoworkspace, 7
      bind = $MOD SHIFT, 8, movetoworkspace, 8
      bind = $MOD SHIFT, 9, movetoworkspace, 9
      bind = $MOD SHIFT, 0, movetoworkspace, 10

      # █▀▄▀█ █▀█ █░█ █▀ █▀▀   █▄▄ █ █▄░█ █▀▄ █ █▄░█ █▀▀
      # █░▀░█ █▄█ █▄█ ▄█ ██▄   █▄█ █ █░▀█ █▄▀ █ █░▀█ █▄█
      bindm = $MOD, mouse:272, movewindow
      bindm = $MOD, mouse:273, resizewindow
      bind = $MOD, mouse_down, workspace, e+1
      bind = $MOD, mouse_up, workspace, e-1


      # █▀█ ▀█▀ █░█ █▀▀ █▀█
      # █▄█ ░█░ █▀█ ██▄ █▀▄
      # submaps
      # Disables all keybinds for moonlight or vm's
      bind = $MOD SHIFT, N, submap, clean
      submap = clean
      bind = $MOD SHIFT, N, submap, reset
      submap = reset

      # use when bug reporting
      # env = AQ_TRACE,1
      # env = HYPRLAND_TRACE,1
      #
      # debug {
      # 	disable_logs = 0
      # 	watchdog_timeout = 0
      # }
      		'';
  };
  imports = [
    ./env.nix
  ];
}
