{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.cfg.programs.hyprland;
  inherit (lib)
    mkIf
    mkDefault
    mkOption
    mapAttrsRecursive
    optionalString
    types
    ;
in
{
  options.cfg.programs.hyprland.hlConfig = mkOption {
    type = types.attrsOf (pkgs.formats.lua { }).type;
    description = "Configuration passed to hl.config";
  };
  config = mkIf cfg.enable {
    # use mapAttrsRecursive here to make every attr in the config
    # a low prio. this means we can override / add any attr below
    # without erroneous mkDefault's or mkForce's everywhere
    cfg.programs.hyprland.hlConfig = mapAttrsRecursive (_: mkDefault) {
      general = {
        # Outer monitor gaps
        # top is 0 because the bar reserves its own gap below it, as room for its shadow
        gaps_out = {
          top = 0;
          right = 5;
          bottom = 5;
          left = 5;
        };
        # Inner window gaps
        gaps_in = 3;
        # Set window border width
        border_size = 2;
        # tearing causes problems and is honestly useless most the time
        allow_tearing = 0;
      };
      render = {
        # only activate DS for games
        direct_scanout = 2;
        # improves cursor latency. doesn't help as much on higher rr though.
        # so just apply it on my laptop
        async_commit = config.cfg.core.isLaptop;
      };
      quirks.skip_non_kms_dmabuf_formats = config.cfg.hardware.nvidia.enable;
      animations.enabled = true;
      decoration = {
        rounding = 6;
        shadow = {
          enabled = true;
          range = 10;
          render_power = 3;
          color = "rgba(00000073)";
          color_inactive = "rgba(00000040)";
        };
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          noise = 0.1;
          vibrancy = 0.2;
          popups = true;
        };
      };
      cursor = {
        default_monitor = cfg.defaultMonitor;
        sync_gsettings_theme = 0;
        # hide cursor after x seconds of inactivity
        inactive_timeout = 4;
        # always try to use hw cursors whenever possible
        no_hardware_cursors = 0;
        # min refresh rate for the cursor in games.
        min_refresh_rate = 30;
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

        # tablet will follow the active monitor.
        tablet.output = "current";
      };
      misc = {
        # Disable hyprland wallpapers etc
        disable_hyprland_logo = 1;
        # Disable text on wallpaper
        disable_splash_rendering = 1;
        background_color = "0x000000";
        # Disables hover for monitor focus
        mouse_move_focuses_monitor = 0;
        # Focuses windows which ask for activation
        focus_on_activate = 1;
        enable_swallow = 0;
        # gui apps executed by beer will swallow it
        swallow_regex = "dev.notashelf.beer";
        vrr = 2; # only apply VRR in fullscreen
        # screencopy_force_8b = false;
        # by default, ANR dialog shows up way too aggressively.
        anr_missed_pings = 6;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        middle_click_paste = false;
        # we launch with Hyprland, not start-hyprland.
        disable_watchdog_warning = true;
        session_lock_xray = true;
      };
      layers = {
        # don't allow bars to be opened above a fullscreen window
        allow_new_top_layers_over_existing_fullscreen = false;
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
  };
}
