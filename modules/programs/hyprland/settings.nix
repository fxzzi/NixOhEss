{
  self,
  self',
  lib,
  pkgs,
  config,
  ...
}: let
  inherit
    (lib)
    mkOption
    mkEnableOption
    types
    mkDefault
    getExe
    getExe'
    optionalAttrs
    mkIf
    optionals
    mod
    ;
  inherit (builtins) concatLists genList;
  cfg = config.cfg.programs.hyprland;
  multiMonitor = cfg.secondaryMonitor != null;
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
      laptop = mkEnableOption {
        description = "Use laptop brightness and keybinds";
      };
    };
  };
  config = {
    hj = {
      xdg.config.files."hypr/hyprland.conf" = {
        generator = self.lib.generators.toHyprlang {
          topCommandsPrefixes = [
            "$"
            "bezier"
            "source"
            "exec-once"
          ];
        };
        value = {
          exec-once = [
            "dbus-update-activation-environment --systemd --all"
            "systemctl --user start hyprland-session.target"
          ];
          exec = optionals multiMonitor [
            "${getExe pkgs.xorg.xrandr} --output ${cfg.defaultMonitor} --primary"
          ];

          exec-shutdown = [
            "pkill -9 Discord" # discord loves to hang instead of close nicely.
            "systemctl --user stop hyprland-session.target"
          ];
          # default settings for monitors
          "monitorv2[]" = {
            position = "auto";
            scale = 1;
            # default 80, 203 is more correct
            max_avg_luminance = 203;
          };
          # fazziPC main monitor
          "monitorv2[desc:GIGA-BYTE TECHNOLOGY CO. LTD. MO27Q28G 25392F000917]" = {
            mode = "2560x1440@280";
            bitdepth = 10;
            cm = "edid";
          };
          # fazziPC secondary monitor
          "monitorv2[desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 20120B000001]" = {
            mode = "2560x1440@170";
            position = "auto-center-left";
            # this monitor does support HDR, but only by technicality.
            # it's implementation is bad. so just disable it entirely.
            supports_hdr = -1;
            bitdepth = 10;
            cm = "edid";
            # icc = "${./icc/M27Q_v1.icc}";
            # we enable vrr globally for fullscreen windows. but this
            # monitor is great with vrr flicker, so enable it always.
            vrr = 1;
          };
          # kunzozPC
          "monitorv2[desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 23080B004543]" = {
            mode = "2560x1440@170";
            # same monitor, same bad hdr
            supports_hdr = -1;
            # this monitor does support 10bit, but only at 120Hz and lower.
            supports_wide_color = -1;
          };
          render = {
            direct_scanout = mkDefault 0;
            non_shader_cm = 2;
            cm_auto_hdr = 2; # use hdredid for autohdr
          };
          cursor = {
            default_monitor = mkIf multiMonitor "${cfg.defaultMonitor}";
            sync_gsettings_theme = 0; # we handle this ourselves
            inactive_timeout = 5; # after x seconds of inactivity, hide the cursor
            no_break_fs_vrr = 0; # NOTE: https://github.com/hyprwm/Hyprland/issues/8582
          };
          input = {
            repeat_rate = 55; # Set characters to repeat on hold every 55ms
            repeat_delay = 375; # Set repeat timeout to 375ms
            follow_mouse = 2; # Follow mouse clicks for window focus
            accel_profile = "flat"; # disable all mouse accel by default
            float_switch_override_focus = 0; # Stop floating windows from stealing focus
            # i hate caps lock, so make it escape instead. also reset f13-f24 to their expected keysyms.
            kb_options = "fkeys:basic_13-24, caps:escape";
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
          general = {
            gaps_out = 2; # Outer monitor gaps
            gaps_in = 1; # Inner window gaps
            border_size = 1; # Set window border width
            allow_tearing = mkDefault 1;
          };
          misc = {
            disable_hyprland_logo = 1; # Disable hyprland wallpapers etc
            disable_splash_rendering = 1; # Disable startup splashscreen
            mouse_move_focuses_monitor = 0; # Disables hover for monitor focus
            focus_on_activate = 1; # Focuses windows which ask for activation
            enable_swallow = 1; # Enable window swalling
            swallow_regex = "foot"; # Make foot swallow executed windows
            swallow_exception_regex = "foot"; # Make foot not swallow itself
            # initial_workspace_tracking = 0;
            vrr = 2;
            anr_missed_pings = 6; # by default, ANR dialog shows up way too aggressively.
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            middle_click_paste = 0;
            # we launch with Hyprland, not start-hyprland.
            disable_watchdog_warning = 1;
          };
          ecosystem = {
            no_update_news = 1;
            no_donation_nag = 1;
          };
          layerrule = [
            "match:namespace launcher, blur 1, ignore_alpha 0"
            "match:namespace wleave, blur 1, xray 1"
            "match:namespace bar-.*, blur 1, xray 1, ignore_alpha 0"
            "match:namespace notifications, blur 1, animation slide"
            # show wayfreeze below slurp, but show both over notifs.
            "match:namespace selection, no_anim 1, order -2"
            "match:namespace wayfreeze, no_anim 1, order -1"
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
              size = 3;
              passes = 3;
              popups = 1;
              # brightness = 0.67;
            };
          };
          animations = {
            enabled = mkDefault 1;
          };
          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];
          animation = let
            wsAnim =
              if multiMonitor
              then "slidevert"
              else "slide";
          in [
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
            "monitorAdded, 0"
          ];

          dwindle = {
            pseudotile = 1;
            preserve_split = 1;
          };
          windowrule =
            [
              # pause hypridle for apps with content type video
              "match:content 2, idle_inhibit focus"
              # hyprland shows anr dialog when stremio is in another workspace, so render_unfocused 1
              "match:class .*stremio.*, idle_inhibit focus, content video, render_unfocused 1"

              "match:class atril, idle_inhibit focus"
              "match:class foot, idle_inhibit fullscreen"

              # some apps, mostly games, are stupid and they fullscreen on the
              # wrong monitor. so just don't listen to them lol
              # also ignore maximize requests from apps. You'll probably like this.
              # some games, like cs2, request tearing by default. disable this.
              "match:class .*, suppress_event maximize fullscreenoutput, immediate 0"

              # dialogs
              "match:title File Operation Progress.*, float 1"
              "match:title Confirm to replace files.*, float 1"
              "match:title Select a File.*, float 1"
              "match:title Save As.*, float 1"
              "match:title Rename.*, float 1"
              "match:class xdg-desktop-portal-gtk, float 1"
              "match:class org.gnome.FileRoller, match:title Extract.*, float 1"

              # make rars launch tiled
              "match:class rars-Launch, match:title RARS .*, tile 1"

              # see: https://github.com/hyprwm/Hyprland/discussions/12786
              "match:class steam, match:title Steam, tile 1"

              # Window rules for games
            ]
            ++ (lib.concatMap (game: [
                # for all game matches
                "match:${game}, idle_inhibit fullscreen, content game"
              ])
              [
                "xdg_tag proton-game" # modern proton versions set xdgTag
                "class steam_app_.*" # all xwayland proton games
                "class cs2"
                "class Minecraft\*.*"
                "initial_title Minecraft\*.*" # sometimes class isn't set
                "class org-prismlauncher-EntryPoint" # legacy mc versions
                "class osu!"
                # "class .*.exe" # all exe's
                "class hl2_linux"
                "class cstrike_linux64" # cs source
                "class portal2_linux"
                "class gamescope"
                "class Celeste"
                "class info.cemu.Cemu"
                "class Cuphead.x86_64"
                "class org.eden_emu.eden"
                "class hollow_knight.x86_64"
                "class Terraria.bin.x86_64"
                "class sm64coopdx"
                "class com.libretro.RetroArch"
                "class dolphin-emu"
              ])
            ++ [
              # content type game means ds will be in effect.
              # ds and tearing cannot activate at the same time.
              # gmd and osu!lazer need tearing for unlocked fps.
              # probably all winewayland stuff too.
              "match:class geometrydash.exe, content none, immediate 1, no_vrr 1"
              "match:class osu!, content none, immediate 1, no_vrr 1"
            ];
          # NOTE: this sets workspaces to alternate if there are 2 monitors.
          workspace = optionalAttrs multiMonitor (
            genList (
              x: let
                workspaceNum = x + 1;
                monitor =
                  if (mod x 2) == 0
                  then cfg.defaultMonitor
                  else cfg.secondaryMonitor;
              in "${toString workspaceNum}, monitor:${monitor}"
            )
            10
          );
          "$MOD" = "SUPER";
          bind = let
            screenshot = getExe self'.packages.screenshot;
          in
            [
              # screenshot script
              ",Print, exec, ${screenshot} --monitor ${cfg.defaultMonitor}"
              "SHIFT, Print, exec, ${screenshot} --selection"
              "$MOD SHIFT, S, exec, ${screenshot} --selection"
              "$MOD, Print, exec, ${screenshot} --active"

              # binds for apps
              "$MOD, F, exec, thunar"
              "$MOD, T, exec, foot"
              "$MOD, B, exec, librewolf"
              "$MOD SHIFT, P, exec, librewolf --private-window"
              "$MOD, W, exec, Discord"
              "$MOD, D, exec, pkill fuzzel || fuzzel"
              "$MOD SHIFT, E, exec, pkill wleave || wleave"
              "CTRL SHIFT, Escape, exec, foot btm"
              # extra schtuff
              "$MOD, N, exec, ${getExe self'.packages.sunset} 3000"
              "$MOD, R, exec, ${getExe self'.packages.random-wall}"
              "$MOD SHIFT, R, exec, hyprctl reload && ${getExe' pkgs.dunst "dunstify"} \"Hyprland\" \"Reloaded Successfully.\""
              "$MOD, J, exec, foot ${getExe self'.packages.wall-picker}"
              "$MOD, L, exec, loginctl lock-session"
              "$MOD, V, exec, pkill fuzzel || (stash list | fuzzel --width 75 --dmenu | stash decode | wl-copy)"

              # mpd media controls
              ", XF86AudioPrev, exec, ${getExe pkgs.mpc} prev"
              ", XF86AudioPlay, exec, ${getExe pkgs.mpc} toggle"
              ", XF86AudioNext, exec, ${getExe pkgs.mpc} next"

              # passthrough binds for obs
              "Control_L, grave, pass, class:com.obsproject.Studio"
              "Control_L SHIFT, grave, pass, class:com.obsproject.Studio"

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
            ++
            # workspaces
            (
              # binds $MOD + [shift +] {1..10} to [move to] workspace {1..10}
              concatLists (
                genList (
                  x: let
                    ws = let
                      c = (x + 1) / 10;
                    in
                      toString (x + 1 - (c * 10));
                  in [
                    "$MOD, ${ws}, workspace, ${toString (x + 1)}"
                    "$MOD SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                  ]
                )
                10
              )
            );

          binde = [
            # resize
            "$MOD CTRL, left, resizeactive, -10 0"
            "$MOD CTRL, right, resizeactive, 10 0"
            "$MOD CTRL, up, resizeactive, 0 -10"
            "$MOD CTRL, down, resizeactive, 0 10"
          ];

          bindel = let
            audio = getExe self'.packages.audio;
            brightness =
              if cfg.laptop
              then getExe self'.packages.brightness-laptop
              else getExe self'.packages.brightness;
          in [
            # volume script
            ", XF86AudioRaiseVolume, exec, ${audio} vol up 5"
            ", XF86AudioLowerVolume, exec, ${audio} vol down 5"
            ", XF86AudioMute, exec, ${audio} vol toggle"
            ", XF86AudioMicMute, exec, ${audio} mic toggle"
            "$MOD SHIFT, M,  exec, ${audio} mic toggle"
            ", F20, exec, ${audio} mic toggle"

            # brightness script
            ", XF86MonBrightnessUp, exec, ${brightness} up 5"
            ", XF86MonBrightnessDown, exec, ${brightness} down 5"
          ];

          # mouse bindings
          bindm =
            [
              "$MOD, mouse:272, movewindow" # left click
              "$MOD, mouse:273, resizewindow" # right click
            ]
            ++ optionals cfg.laptop [
              "$MOD, Control_L, movewindow"
              "$MOD, ALT_L, resizewindow"
            ];

          gesture = [
            "3, horizontal, workspace"
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
