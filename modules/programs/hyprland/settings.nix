{
  self,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.cfg.programs.hyprland;
  inherit
    (lib)
    boolToString
    generators
    getExe
    getExe'
    mkIf
    mkDefault
    mapAttrsRecursive
    optionalString
    ;

  multiMonitor = cfg.secondaryMonitor != null;
  secondaryMonitor =
    if multiMonitor
    then cfg.secondaryMonitor
    else cfg.defaultMonitor;

  # pkgs
  selfPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  screenshot = getExe selfPkgs.screenshot;
  audio = getExe selfPkgs.audio;
  brightness =
    if config.cfg.core.isLaptop
    then getExe selfPkgs.brightness-laptop # uses brightnessctl
    else getExe selfPkgs.brightness; # uses hyprsunset instead
  mpc = getExe pkgs.mpc;
  killall = getExe pkgs.killall;
in {
  config = mkIf cfg.enable {
    # use mapAttrs here to make every attr in the config a low prio
    # this means we can override / add any attr below without
    # erroneous mkDefault's or mkForce's everywhere
    cfg.programs.hyprland.config = mapAttrsRecursive (_: mkDefault) {
      general = {
        # Outer monitor gaps
        gaps_out = 2;
        # Inner window gaps
        gaps_in = 1;
        # Set window border width
        border_size = 1;
        # tearing causes problems and is honestly useless most the time
        allow_tearing = 0;
      };
      render = {
        cm_enabled = 1;
        # only activate DS for games
        direct_scanout = 2;
      };
      # allows DS to activate with winewayland on nvidia,
      # and also fixes mpv freezing in fullscreen with DS
      quirks.skip_non_kms_dmabuf_formats = config.cfg.hardware.nvidia.enable;
      animations.enabled = 1;
      decoration = {
        rounding = 0;
        shadow.enabled = 0;
        blur = {
          enabled = 1;
          size = 3;
          passes = 3;
        };
      };
      cursor = {
        default_monitor = cfg.defaultMonitor;
        # we handle this ourselves
        sync_gsettings_theme = 0;
        # hide cursor after x seconds of inactivity
        inactive_timeout = 4;
        # allow cursor to run at full fps in games
        no_break_fs_vrr = 0;
        # always try to use hw cursors whenever possible
        no_hardware_cursors = 0;
      };
      input = {
        # Set characters to repeat on hold every Xms
        repeat_rate = 55;
        # Set repeat timeout to Xms
        repeat_delay = 375;
        # Follow mouse clicks for window focus
        follow_mouse = 2;
        # disable all mouse accel by default
        accel_profile = "flat";
        # Stop floating windows from stealing focus
        float_switch_override_focus = 0;
        # make touchpad scroll in the expected directions
        touchpad.natural_scroll = true;
        # set f13-f24 to their expected keysyms instead of xf86 stuff.
        # this allows them to be binded in apps like OBS, and CS2
        # don't apply this on laptops though, because it'll mess with
        # keys like brightness, micmute, etc.
        kb_options = optionalString (!config.cfg.core.isLaptop) "fkeys:basic_13-24";
      };
      misc = {
        # Disable hyprland wallpapers etc
        disable_hyprland_logo = 1;
        # Disable startup splashscreen
        disable_splash_rendering = 1;
        background_color = "0x000000";
        # Disables hover for monitor focus
        mouse_move_focuses_monitor = 0;
        # Focuses windows which ask for activation
        focus_on_activate = 1;
        enable_swallow = 0;
        # gui apps executed by foot will swallow it
        swallow_regex = "foot";
        vrr = 2;
        # by default, ANR dialog shows up way too aggressively.
        anr_missed_pings = 6;
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
      dwindle.preserve_split = true; # You probably want this
      debug = {
        # make sure to uncomment when debugging
        # disable_logs = false;
      };
    };

    hj.xdg.config.files."hypr/hyprland.lua" = {
      text =
        # lua
        ''
          -- fallback monitor config
          hl.monitor({
            output = "",
            mode = "highres",
            position = "auto",
            scale = "1",
          })

          hl.on("hyprland.shutdown", function()
            -- discord literally shits itself and coredumps if the graphical env
            -- is shut down whilst it's still open. kill it to avoid the coredump.
            hl.exec_cmd("pkill -9 Discord")
          end)

          -- set primary monitor in both monitor events to be safe
          if ${boolToString multiMonitor} then
            local function set_primary()
              hl.exec_cmd("${getExe pkgs.xrandr} --output ${cfg.defaultMonitor} --primary")
            end
            hl.on("monitor.added", set_primary)
            hl.on("monitor.removed", set_primary)
            hl.on("config.reloaded", set_primary)
          end

          -- apply the config block from nix
          hl.config(${generators.toLua {} cfg.config})

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
          -- emulators and similar apps that should be tagged as games, but not forced fullscreen
          for _, match in ipairs({
            { class = "info.cemu.Cemu" },
            { class = "org.eden_emu.eden" },
            { class = "dev.eden_emu.eden" },
            { class = "dolphin-emu" },
          }) do
            hl.window_rule({ match = match, tag = "+game" })
          end

          -- wine/proton/native titles that should launch fullscreen
          for _, match in ipairs({
            { xdg_tag = "proton-game" }, -- proton w/ wine-wayland sets this
            { class = "steam_app_.*" }, -- umu / proton xwayland set this
            { class = "com.libretro.RetroArch" },
            { class = ".*_linux" }, -- 32-bit source
            { class = ".*_linux64" }, -- 64-bit source
            { class = ".*.x86_64" }, -- native sdl games
            { class = "momentum" }, -- momentum mod
            { class = "cs2" },
            { class = "org-prismlauncher-EntryPoint" }, -- legacy mc
            { initial_title = "Minecraft\\* .*" }, -- mc up to v26.1
            { initial_title = "Minecraft .*" }, -- v26.2+ mc
            { class = "osu!" },
            { class = "gamescope" },
            { class = "Celeste" },
            { class = "sm64coopdx" },
            { class = "UnleashedRecomp" },
            { class = "sober" },
            { class = "waywall" },
            { class = "love", title = "Freesync test" },
          }) do
            hl.window_rule({ match = match, tag = "+game", fullscreen = true })
          end

          -- apply behavior by tag
          hl.window_rule({ match = { tag = "game" }, content = "game", idle_inhibit = "fullscreen", immediate = true})

          -- confine cursor to the monitor when a game is in fullscreen.
          if ${boolToString multiMonitor} then
            hl.window_rule({ match = { content = "game", fullscreen = true }, confine_pointer = true })
          end

          local function curves(items)
            for name, points in pairs(items) do
              hl.curve(name, {
                type = "bezier",
                points = points,
              })
            end
          end

          local function animations(items)
            for _, a in ipairs(items) do
              hl.animation({
                leaf = a[1],
                enabled = a[2],
                speed = a[3],
                bezier = a[4],
                style = a[5],
              })
            end
          end

          local function bind(keys, action, opts)
            hl.bind(table.concat(keys, " + "), action, opts)
          end

          -- Curves
          curves({
            easeOutQuint = { { 0.23, 1 }, { 0.32, 1 } },
            easeInOutCubic = { { 0.65, 0.05 }, { 0.36, 1 } },
            linear = { { 0, 0 }, { 1, 1 } },
            almostLinear = { { 0.5, 0.5 }, { 0.75, 1 } },
            quick = { { 0.15, 0 }, { 0.1, 1 } },
          })

          -- Animations
          animations({
            { "windowsIn", true, 3, "easeOutQuint", "slide" },
            { "windowsOut", true, 3, "easeOutQuint", "slide" },
            { "windowsMove", true, 3, "easeOutQuint" },
            { "layersIn", true, 4, "easeOutQuint", "fade" },
            { "layersOut", true, 1.5, "linear", "fade" },
            { "fadeIn", true, 1.2, "almostLinear" },
            { "fadeOut", true, 2, "almostLinear" },
            { "fadeSwitch", true, 1.2, "almostLinear" },
            { "fadeShadow", true, 1.2, "almostLinear" },
            { "fadeDim", true, 1.2, "almostLinear" },
            { "fadeLayers", true, 1.4, "linear" },
            { "fadePopups", true, 2, "linear" },
            { "border", true, 5, "easeOutQuint" },
            { "specialWorkspace", true, 3, "quick", "fade" },
            { "zoomFactor", true, 4, "quick" },
            -- wsAnim will be vertical if multi-monitor, otherwise the animation will be weird
            -- and it will look like windows are moving into each other across the monitors.
            { "workspaces", true, 4, "easeOutQuint", ${boolToString multiMonitor} and "slidevert" or "slide" },
            -- disable the bootup animation
            { "monitorAdded", false },
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
          bind({ "Print" }, hl.dsp.exec_raw("${screenshot} --monitor"))
          bind({ "SHIFT", "Print" }, hl.dsp.exec_raw("${screenshot} --selection"))
          bind({ mainMod, "SHIFT", "S" }, hl.dsp.exec_raw("${screenshot} --selection"))
          bind({ mainMod, "Print" }, hl.dsp.exec_raw("${screenshot} --active"))

          -- annotate the image in clipboard
          bind({mainMod, "A"}, hl.dsp.exec_raw("wl-paste | ${getExe pkgs.swappy} -f -"))

          -- binds for apps
          bind({ mainMod, "F" }, hl.dsp.exec_raw("thunar"))
          bind({ mainMod, "T" }, hl.dsp.exec_raw("foot"))
          bind({ mainMod, "B" }, hl.dsp.exec_raw("librewolf"))
          bind({ mainMod, "SHIFT", "P" }, hl.dsp.exec_raw("librewolf --private-window"))
          bind({ mainMod, "W" }, hl.dsp.exec_raw("Discord"))
          bind({ mainMod, "D" }, hl.dsp.exec_raw("pkill fuzzel || fuzzel"))
          bind({ mainMod, "SHIFT", "E" }, hl.dsp.exec_raw("pkill wleave || wleave"))
          bind({ "CTRL", "SHIFT", "Escape" }, hl.dsp.exec_raw("foot btm"))
          -- extra schtuff
          bind({ mainMod, "N" }, hl.dsp.exec_raw("${getExe selfPkgs.sunset} 3000"))
          bind({ mainMod, "R" }, hl.dsp.exec_raw("${getExe selfPkgs.random-wall}"))
          bind({ mainMod, "SHIFT", "R" }, hl.dsp.exec_raw("hyprctl reload && ${getExe' pkgs.dunst "dunstify"} 'Hyprland' 'Reloaded Successfully.'"))
          bind({ mainMod, "K" }, hl.dsp.exec_raw("hyprctl kill"))
          bind({ mainMod, "J" }, hl.dsp.exec_raw("foot ${getExe selfPkgs.wall-picker}"))
          bind({ mainMod, "L" }, hl.dsp.exec_raw("loginctl lock-session"))
          bind({ mainMod, "V" }, hl.dsp.exec_raw("pkill fuzzel || (stash list | fuzzel --width 75 --dmenu | stash decode | wl-copy)"))

          -- mpd media controls
          bind({ "XF86AudioPrev" }, hl.dsp.exec_raw("${mpc} prev"))
          bind({ "XF86AudioPlay" }, hl.dsp.exec_raw("${mpc} toggle"))
          bind({ "XF86AudioNext" }, hl.dsp.exec_raw("${mpc} next"))

          -- shortcuts for OBS
          bind({ "CTRL", "SHIFT", "grave" }, hl.dsp.global(":_toggle_recording"))
          bind({ "CTRL", "grave" }, hl.dsp.global(":ReplayBuffer.Save"))

          -- also for gpu-screen-recorder.
          -- SIGINT saves the recording (wont start a recording for now)
          bind({ "CTRL", "SHIFT", "grave" }, hl.dsp.exec_raw("${killall} -SIGINT gpu-screen-recorder"))
          -- SIGUSR1 saves the replay
          bind({ "CTRL", "grave" }, hl.dsp.exec_raw("${killall} -SIGUSR1 gpu-screen-recorder"))

          -- window management
          bind({ mainMod, "Q" }, hl.dsp.window.close())
          bind({ mainMod, "Space" }, hl.dsp.window.fullscreen(1))
          bind({ mainMod, "Tab" }, hl.dsp.window.float({ action = "toggle" }))
          bind({ mainMod, "P" }, hl.dsp.window.pseudo())
          bind({ mainMod, "S" }, hl.dsp.layout("togglesplit"))

          -- focus
          for _, dir in ipairs({ "left", "right", "up", "down" }) do
            bind({ mainMod, dir }, hl.dsp.focus({ direction = dir }))
          end

          -- move
          for _, dir in ipairs({ "left", "right", "up", "down" }) do
            bind({ mainMod, "SHIFT", dir }, hl.dsp.window.move({ direction = dir }))
          end

          for i = 1, 10 do
              local key = i % 10 -- 10 maps to key 0
              bind({ mainMod, tostring(key) }, hl.dsp.focus({ workspace = i }))
              bind({ mainMod, "SHIFT", tostring(key) }, hl.dsp.window.move({ workspace = i }))
          end

          -- navigate through workspaces on mouse
          bind({ mainMod, "mouse_down" }, hl.dsp.focus({ workspace = "e+1" }))
          bind({ mainMod, "mouse_up" }, hl.dsp.focus({ workspace = "e-1" }))

          -- resize
          for _, resize in ipairs({
            { "left", -10, 0 },
            { "right", 10, 0 },
            { "up", 0, -10 },
            { "down", 0, 10 },
          }) do
            bind(
              { mainMod, "CTRL", resize[1] },
              hl.dsp.window.resize({ x = resize[2], y = resize[3], relative = true }),
              { repeating = true }
            )
          end

          -- audio binds
          for _, a in ipairs({
            { { "XF86AudioRaiseVolume" }, "${audio} vol up 5" },
            { { "SHIFT", "XF86AudioRaiseVolume" }, "${audio} vol up 1" },

            { { "XF86AudioLowerVolume" }, "${audio} vol down 5" },
            { { "SHIFT", "XF86AudioLowerVolume" }, "${audio} vol down 1" },

            { { "XF86AudioMute" }, "${audio} vol toggle" },

            { { "XF86AudioMicMute" }, "${audio} mic toggle" },
            { { mainMod, "SHIFT", "M" }, "${audio} mic toggle" },
          }) do
            bind(a[1], hl.dsp.exec_raw(a[2]), { locked = true, repeating = true })
          end

          -- brightness binds
          for _, b in ipairs({
            { "XF86MonBrightnessUp", "up" },
            { "XF86MonBrightnessDown", "down" },
          }) do
            bind({ b[1] }, hl.dsp.exec_raw("${brightness} " .. b[2] .. " 5"), { locked = true, repeating = true })
          end

          -- mouse binds
          bind({ mainMod, "mouse:272" }, hl.dsp.window.drag(), { mouse = true }) -- left click
          bind({ mainMod, "mouse:273" }, hl.dsp.window.resize(), { mouse = true }) -- right click
          -- these binds allow you to easily drag and resize on touchpad
          if ${boolToString config.cfg.core.isLaptop} then
            bind({ mainMod, "CTRL" }, hl.dsp.window.drag(), { mouse = true })
            bind({ mainMod, "ALT" }, hl.dsp.window.resize(), { mouse = true })
          end
        '';
    };
  };
}
