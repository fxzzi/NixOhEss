{
  self,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cfg.programs.hyprland;
  inherit (lib) mkOption types getExe mkIf getExe' boolToString;

  inherit (config.cfg.core) isLaptop;
  isNvidia = config.cfg.hardware.nvidia.enable;
  multiMonitor = cfg.secondaryMonitor != null;
  secondaryMonitor =
    if cfg.secondaryMonitor != null
    then cfg.secondaryMonitor
    else "hereBeDragons"; # things using secondaryMonitor should always be gated

  # pkgs
  inherit (pkgs.stdenv.hostPlatform) system;
  screenshot = getExe self.packages.${system}.screenshot;
  audio = getExe self.packages.${system}.audio;
  brightness =
    if isLaptop
    then getExe self.packages.${system}.brightness-laptop
    else getExe self.packages.${system}.brightness;
  mpc = getExe pkgs.mpc;
  killall = getExe pkgs.killall;
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
  config = mkIf cfg.enable {
    hj.xdg.config.files."hypr/hyprland.lua" = {
      text =
        # lua
        ''
          hl.monitor({
            output = "",
            mode = "highres",
            position = "auto",
            scale = "1",
          })

            hl.on("hyprland.start", function()
              hl.exec_cmd("systemctl --user reset-failed")
              hl.exec_cmd("systemctl --user start nixos-fake-graphical-session.target")
            end)

            hl.on("hyprland.shutdown", function()
              hl.exec_cmd("pkill -9 Discord")
              hl.exec_cmd("systemctl stop --user nixos-fake-graphical-session.target")
            end)

            -- set primary monitor in all 3 events to be safe
            local function set_primary()
              hl.exec_cmd("${lib.getExe pkgs.xrandr} --output ${cfg.defaultMonitor} --primary")
            end
            if ${boolToString multiMonitor} then
              hl.on("monitor.added", set_primary)
              hl.on("monitor.removed", set_primary)
              hl.on("config.reloaded", set_primary)
            end

            hl.config({
              general = {
                gaps_out = 2, -- Outer monitor gaps
                gaps_in = 1, -- Inner window gaps
                border_size = 1, -- Set window border width
                allow_tearing = 0,
              },
              render = {
                direct_scanout = 2, -- only activate DS for games
                cm_auto_hdr = 2, -- use values from edid for HDR
                use_fp16 = 2,
              },
              cursor = {
                default_monitor = "${cfg.defaultMonitor}",
                sync_gsettings_theme = 0, -- we handle this ourselves
                inactive_timeout = 4, -- hide cursor after x seconds of inactivity
                no_break_fs_vrr = 2, -- vrr fixes for games only
                -- always try to use hw cursors whenever possible
                no_hardware_cursors = 0,
              },
              input = {
                repeat_rate = 55, -- Set characters to repeat on hold every Xms
                repeat_delay = 375, -- Set repeat timeout to Xms
                follow_mouse = 2, -- Follow mouse clicks for window focus
                accel_profile = "flat", -- disable all mouse accel by default
                float_switch_override_focus = 0, -- Stop floating windows from stealing focus
                -- set f13-f24 to their expected keysyms instead of xf86 stuff.
                -- this allows them to be binded in apps like OBS, and CS2
                kb_options = "fkeys:basic_13-24",
                touchpad = {
                  natural_scroll = true,
                },
              },
              misc = {
                disable_hyprland_logo = 1, -- Disable hyprland wallpapers etc
                disable_splash_rendering = 1, -- Disable startup splashscreen
                background_color = "0x000000",
                mouse_move_focuses_monitor = 0, -- Disables hover for monitor focus
                focus_on_activate = 1, -- Focuses windows which ask for activation
                enable_swallow = 0,
                swallow_regex = "foot", -- gui apps executed by foot will swallow it
                vrr = 2,
                anr_missed_pings = 6, -- by default, ANR dialog shows up way too aggressively.
                mouse_move_enables_dpms = true,
                key_press_enables_dpms = true,
                middle_click_paste = 0,
                -- we launch with Hyprland, not start-hyprland.
                disable_watchdog_warning = 1,
              },
              ecosystem = {
                no_update_news = 1,
                no_donation_nag = 1,
              },
              decoration = {
                rounding = 0,
                shadow = { enabled = 0 },
                blur = {
                  enabled = 1,
                  size = 3,
                  passes = 3,
                },
              },
              animations = {
                 enabled = ${boolToString (!isLaptop)},
              },
              dwindle = {
                preserve_split = true, -- You probably want this
              },
              debug = {
                invalidate_fp16 = 1,
              },
            })

            if ${boolToString isNvidia} then
              hl.config({
                -- allow DS to activate with winewayland on nvidia
                -- also fix mpv freezing in fullscreen with DS
                quirks = { skip_non_kms_dmabuf_formats = 1 },
              })
            end

            hl.layer_rule({ match = { namespace = "launcher" }, blur = true, ignore_alpha = 0 })
            hl.layer_rule({ match = { namespace = "wleave" }, blur = true, xray = true })
            hl.layer_rule({ match = { namespace = "bar-.*" }, blur = true, xray = true, ignore_alpha = 0 })
            hl.layer_rule({ match = { namespace = "notifications" }, blur = true, animation = "slide" })
            -- show `still` below `slurp`, but above notifications
            -- used to freeze screen during selection screenshots
            hl.layer_rule({ match = { namespace = "selection" }, no_anim = true, order = -2 })
            hl.layer_rule({ match = { namespace = "still" }, no_anim = true, order = -1 })

            -- hyprland shows anr dialog when stremio is in another workspace, so render_unfocused 1
            hl.window_rule({ match = { class = ".*stremio.*" }, render_unfocused = true, content = "video" })
            -- no vrr on video content, like mpv
            hl.window_rule({ match = { content = "video" }, idle_inhibit = "fullscreen", no_vrr = true })

            hl.window_rule({ match = { class = "atril" }, idle_inhibit = "focus" })

            -- oled flicker is annoying on some apps
            hl.window_rule({ match = { class = "foot" }, idle_inhibit = "fullscreen", no_vrr = true })
            hl.window_rule({ match = { class = "org.gnome.Loupe" }, no_vrr = true })

            -- some apps, mostly games, are stupid and they fullscreen on the
            -- wrong monitor. so just don't listen to them lol
            -- also ignore maximize requests from apps. You'll probably like this.
            -- some games, like cs2, request tearing by default. disable this.
            hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize fullscreenoutput" })

            -- dialogs
            hl.window_rule({ match = { title = "File Operation Progress.*" }, float = true })
            hl.window_rule({ match = { title = "Confirm to replace files.*" }, float = true })
            hl.window_rule({ match = { title = "Select a File.*" }, float = true })
            hl.window_rule({ match = { title = "Save As.*" }, float = true })
            hl.window_rule({ match = { title = "Rename.*" }, float = true })
            hl.window_rule({ match = { class = "xdg-desktop-portal-gtk" }, float = true })
            hl.window_rule({ match = { class = "org.gnome.FileRoller", title = "Extract.*" }, float = true })

            -- make some java apps launch tiled
            hl.window_rule({ match = { class = "rars-Launch", title = "RARS .*" }, tile = true })
            hl.window_rule({ match = { class = "com-cburch-logisim-Main", title = ".*Logisim-evolution v.*" }, tile = true })

            -- see: https://github.com/hyprwm/Hyprland/discussions/12786
            hl.window_rule({ match = { class = "steam", title = "Steam" }, tile = true })

            -- Window rules for games
            -- wine, proton, etc
            hl.window_rule({ match = { xdg_tag = "proton-game" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { class = "steam_app_.*" }, content = "game", fullscreen = true })

            -- emulators
            hl.window_rule({ match = { class = "info.cemu.Cemu" }, content = "game" })
            hl.window_rule({ match = { class = "org.eden_emu.eden" }, content = "game" })
            hl.window_rule({ match = { class = "dev.eden_emu.eden" }, content = "game" })
            hl.window_rule({ match = { class = "dolphin-emu" }, content = "game" })
            hl.window_rule({ match = { class = "com.libretro.RetroArch" }, content = "game", fullscreen = true })

            -- native
            hl.window_rule({ match = { class = ".*_linux" }, content = "game", fullscreen = true }) -- 32-bit source
            hl.window_rule({ match = { class = ".*_linux64" }, content = "game", fullscreen = true }) -- 64-bit source
            hl.window_rule({ match = { class = ".*.x86_64" }, content = "game", fullscreen = true }) -- native sdl games
            hl.window_rule({ match = { class = "momentum" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { class = "cs2" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { class = "Minecraft\\*.*" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { initial_title = "Minecraft\\*.*" }, content = "game", fullscreen = true }) -- sometimes class isn't set
            hl.window_rule({ match = { class = "org-prismlauncher-EntryPoint" }, content = "game", fullscreen = true }) -- legacy mc versions
            hl.window_rule({ match = { class = "osu!" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { class = "gamescope" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { class = "Celeste" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { class = "sm64coopdx" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { class = "UnleashedRecomp" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { class = "sober" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { class = "waywall" }, content = "game", fullscreen = true })
            hl.window_rule({ match = { class = "love", title = "Freesync test" }, content = "game", fullscreen = true })

            hl.window_rule({ match = { content = "game" }, idle_inhibit = "fullscreen", immediate = true })

            -- Curves
            hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
            hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
            hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
            hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
            hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

            -- Animations
            hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slide" })
            hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slide" })
            hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "easeOutQuint" })

            hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
            hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })

            hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.2, bezier = "almostLinear" })
            hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "almostLinear" })
            hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 1.2, bezier = "almostLinear" })
            hl.animation({ leaf = "fadeShadow", enabled = true, speed = 1.2, bezier = "almostLinear" })
            hl.animation({ leaf = "fadeDim", enabled = true, speed = 1.2, bezier = "almostLinear" })
            hl.animation({ leaf = "fadeLayers", enabled = true, speed = 1.4, bezier = "linear" })
            hl.animation({ leaf = "fadePopups", enabled = true, speed = 2, bezier = "linear" })

            hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "easeOutQuint" })
            hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "quick", style = "fade" })
            hl.animation({ leaf = "zoomFactor", enabled = true, speed = 4, bezier = "quick" })
            -- disable the bootup animation
            hl.animation({ leaf = "monitorAdded", enabled = false })


            hl.animation({
              leaf = "workspaces",
              enabled = true,
              speed = 4,
              bezier = "easeOutQuint",
              -- wsAnim will be vertical if multi-monitor, otherwise the animation will be weird
              -- and it will look like windows are moving into each other across the monitors.
              style = ${boolToString multiMonitor} and "slidevert" or "slide",
            })

            hl.device({
              name = "at-translated-set-2-keyboard", -- thinkpad l14 keyboard
              kb_layout = "gb",
            })

            hl.device({
              name = "elan0680:00-04f3:320a-touchpad", -- thinkpad l14 touchpad
              accel_profile = "adaptive",
            })

            hl.gesture({
              fingers = 3,
              direction = "horizontal",
              action = "workspace",
            })

            -- set workspaces to alternate between monitors when there are 2 monitors.
            if ${boolToString multiMonitor} then
              for i = 1, 10 do
                local monitor = (i % 2 == 1) and "${cfg.defaultMonitor}" or "${secondaryMonitor}"
                hl.workspace_rule({
                  workspace = tostring(i),
                  monitor = monitor,
                })
              end
            end

            local mainMod = "SUPER"

            -- screenshot script
            hl.bind("Print", hl.dsp.exec_cmd("${screenshot} --monitor"))
            hl.bind("SHIFT + Print", hl.dsp.exec_cmd("${screenshot} --selection"))
            hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("${screenshot} --selection"))
            hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("${screenshot} --active"))

            -- binds for apps
            hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("thunar"))
            hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("foot"))
            hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("librewolf"))
            hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("librewolf --private-window"))
            hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("Discord"))
            hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("pkill fuzzel || fuzzel"))
            hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("pkill wleave || wleave"))
            hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("foot btm"))
            -- extra schtuff
            hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("${getExe self.packages.${system}.sunset} 3000"))
            hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("${getExe self.packages.${system}.random-wall}"))
            hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload && ${getExe' pkgs.dunst "dunstify"} 'Hyprland' 'Reloaded Successfully.'"))
            hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("hyprctl kill"))
            hl.bind(mainMod .. " + J", hl.dsp.exec_cmd("foot ${getExe self.packages.${system}.wall-picker}"))
            hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
            hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("pkill fuzzel || (stash list | fuzzel --width 75 --dmenu | stash decode | wl-copy)"))

            -- mpd media controls
            hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${mpc} prev"))
            hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${mpc} toggle"))
            hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${mpc} next"))

            -- shortcuts for OBS
            hl.bind("CTRL + SHIFT + grave", hl.dsp.global(":_toggle_recording"))
            hl.bind("CTRL + grave", hl.dsp.global(":ReplayBuffer.Save"))

            -- also for gpu-screen-recorder.
            -- SIGINT saves the recording (wont start a recording for now)
            hl.bind("CTRL + SHIFT + grave", hl.dsp.exec_cmd("${killall} -SIGINT gpu-screen-recorder"))
            -- SIGUSR1 saves the replay
            hl.bind("CTRL + grave", hl.dsp.exec_cmd("${killall} -SIGUSR1 gpu-screen-recorder"))

            -- window management
            hl.bind(mainMod .. " + Q", hl.dsp.window.close())
            hl.bind(mainMod .. " + Space", hl.dsp.window.fullscreen(1))
            hl.bind(mainMod .. " + Tab", hl.dsp.window.float({ action = "toggle" }))
            hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
            hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit"))

            -- focus
            hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
            hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
            hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
            hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

            -- move
            hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
            hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
            hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
            hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

            for i = 1, 10 do
                local key = i % 10 -- 10 maps to key 0
                hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}))
                hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
            end

            -- navigate through workspaces on mouse
            hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
            hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

            -- resize
            hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
            hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
            hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
            hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

            -- audio binds
            hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${audio} vol up 5"), { locked = true, repeating = true })
            hl.bind("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("${audio} vol up 1"), { locked = true, repeating = true })
            hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${audio} vol down 5"), { locked = true, repeating = true })
            hl.bind("SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd("${audio} vol down 1"), { locked = true, repeating = true })
            hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${audio} vol toggle"), { locked = true, repeating = true })
            hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("${audio} mic toggle"), { locked = true, repeating = true })
            hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("${audio} mic toggle"), { locked = true, repeating = true })
            hl.bind("F20", hl.dsp.exec_cmd("${audio} mic toggle"), { locked = true, repeating = true })

            -- brightness binds
            hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("${brightness} up 5"), { locked = true, repeating = true })
            hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("${brightness} down 5"), { locked = true, repeating = true })

            -- mouse binds
            hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- left click
            hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- right click
            if ${boolToString isLaptop} then
              hl.bind(mainMod .. " + CTRL", hl.dsp.window.drag(), { mouse = true })
              hl.bind(mainMod .. " + ALT", hl.dsp.window.resize(), { mouse = true })
            end
        '';
    };
  };
}
