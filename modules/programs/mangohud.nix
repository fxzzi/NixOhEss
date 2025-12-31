{
  pkgs,
  self',
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  inherit (builtins) toString;
  cfg = config.cfg.programs.mangohud;

  fpsLimit = let
    rr = cfg.refreshRate;
  in
    if config.hj.xdg.config.files."hypr/hyprland.conf".value.misc.vrr == 0
    then rr
    # NOTE: https://old.reddit.com/r/nvidia/comments/1lokih2/putting_misconceptions_about_optimal_fps_caps/
    else (rr - (rr * rr / 4096));
in {
  options.cfg.programs.mangohud = {
    enable = mkEnableOption "mangohud";
    enableSessionWide = mkOption {
      type = types.bool;
      default = false;
      description = "Enable MangoHud for all Vulkan apps.";
    };
    refreshRate = mkOption {
      type = types.int;
      default = 170;
      description = ''
        If VRR is disabled in Hyprland, games will be locked to this refresh rate.
        With VRR enabled, games will be locked to a refresh rate slightly lower than this value.
      '';
    };
  };
  config = mkIf cfg.enable {
    environment.sessionVariables = mkIf cfg.enableSessionWide {
      "MANGOHUD" = "1";
    };
    hj = {
      # mangohud with some patches for hdr
      packages = [self'.packages.mangohud-patched];
      xdg.config.files = {
        "MangoHud/MangoHud.conf".text = ''
          blacklist=mpv
          text_outline_thickness=1
          font_size_small=14
          # normally this is #000000, but it isn't correctly
          # tonemapped in HDR. So lighten it ourselves
          text_outline_color=262626
          cellpadding_y=-0.3
          fps_limit=${toString fpsLimit},0
          vsync=1
          gl_vsync=0
          preset=0,1,2
          toggle_hud=Shift_R+F12
          toggle_hud_position=Shift_R+F11
          toggle_preset=Shift_R+F10
        '';
        "MangoHud/presets.conf".text = let
          mono = "${pkgs.jetbrains-mono}/share/fonts/opentype/JetBrainsMono-Regular.otf";
          sans = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
          common = ''
            font_size=20
            font_file=${mono}
            background_alpha=0.33
            hud_no_margin
            gpu_stats
            gpu_core_clock
            gpu_mem_clock
            gpu_temp
            gpu_power
            vram
            fps
            frame_timing
            cpu_mhz
            cpu_stats
            cpu_temp
            cpu_power
            ram
          '';
        in ''
          # mimic the basic steam fps counter
          [preset 0]
          font_file=${sans}
          font_size=15
          text_outline=false
          alpha=0.75
          fps_only
          background_alpha=0
          hud_no_margin
          hud_compact

          [preset 1]
          ${common}

          [preset 2]
          ${common}
          core_load
        '';
      };
    };
  };
}
