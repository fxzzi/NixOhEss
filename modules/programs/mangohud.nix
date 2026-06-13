{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf generators;
  inherit (builtins) toString;
  cfg = config.cfg.programs.mangohud;

  # When using VRR it's recommended to limit your FPS to slightly below your refresh rate. In the past,
  # it was recommended to just put your FPS cap at ~3 lower than your refresh rate. However the more
  # correct behaviour is to provide a frame time gap. This gap becomes larger at higher refresh rates
  # and allows you to stay within the VRR range easily at the cost of a few measly FPS.
  # see: https://old.reddit.com/r/nvidia/comments/1lokih2/putting_misconceptions_about_optimal_fps_caps/
  fpsLimit = let
    rr = cfg.refreshRate;
    inherit (config.cfg.programs.hyprland.extraHlConfig.misc) vrr;
  in
    if vrr != 0
    then rr - (rr * rr / 4096)
    else rr;
in {
  options.cfg.programs.mangohud = {
    enable = mkEnableOption "MangoHud";
    enableSessionWide = mkEnableOption "MangoHud for all Vulkan apps";
    refreshRate = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        Games will be locked to a refresh rate slightly lower than this value.
        If this option is left at `null`, no FPS limit will be set.
      '';
    };
  };
  config = mkIf cfg.enable {
    environment.sessionVariables = mkIf cfg.enableSessionWide {
      MANGOHUD = 1;
    };
    hj = {
      # mangohud with some patches for hdr
      packages = [inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.mangohud-patched];
      xdg.config.files = {
        "MangoHud/MangoHud.conf" = {
          generator = generators.toKeyValue {};
          value = {
            blacklist = "mpv";
            text_outline_thickness = 1;
            font_size_small = 14;
            # normally this is #000000, but it isn't correctly
            # tonemapped in HDR. So lighten it ourselves
            text_outline_color = 262626;
            cellpadding_y = -0.3;
            fps_limit = mkIf (cfg.refreshRate != null) "${toString fpsLimit},0";
            vsync = 1;
            gl_vsync = 0;
            vulkan_present_mode = "fifo_latest_ready";
            preset = "0,1,2";
            toggle_hud = "Shift_R+F12";
            toggle_hud_position = "Shift_R+F11";
            toggle_preset = "Shift_R+F10";
          };
        };
        "MangoHud/presets.conf" = let
          mono = "${pkgs.jetbrains-mono}/share/fonts/opentype/JetBrainsMono-Regular.otf";
          sans = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
          common = {
            font_size = 20;
            font_file = mono;
            background_alpha = 0.42;
            hud_no_margin = 1;
            gpu_stats = 1;
            gpu_core_clock = 1;
            gpu_mem_clock = 1;
            gpu_temp = 1;
            gpu_power = 1;
            vram = 1;
            fps = 1;
            frame_timing = 1;
            cpu_mhz = 1;
            cpu_stats = 1;
            cpu_temp = 1;
            cpu_power = 1;
            ram = 1;
          };
        in {
          generator = generators.toINI {};
          value = {
            "preset 0" = {
              font_file = sans;
              font_size = 16;
              text_outline = false;
              alpha = 0.67;
              fps_only = 1;
              background_alpha = 0;
              hud_no_margin = 1;
              hud_compact = 1;
            };
            "preset 1" = common;
            "preset 2" =
              common
              // {
                core_load = 1;
                present_mode = 1;
                winesync = 1;
              };
          };
        };
      };
    };
  };
}
