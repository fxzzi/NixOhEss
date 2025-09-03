{
  config,
  lib,
  pkgs,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  inherit (builtins) substring toString;
  cfg = config.cfg.programs.mangohud;

  fpsLimit = let
    rr = cfg.refreshRate;
  in
    if config.hj.xdg.config.files."hypr/hyprland.conf".value.misc.vrr == 0
    then rr
    # NOTE:https://old.reddit.com/r/nvidia/comments/1lokih2/putting_misconceptions_about_optimal_fps_caps/
    else (rr - (rr * rr / 4096));

  # override MangoHud to latest git until next release.
  # fixes keybinds on native wayland games, and avoids mangohud
  # showing up on all gtk4 apps (and mpv).
  mangohud = pkgs.mangohud.overrideAttrs {
    version = "0-unstable-${substring 0 8 npins.MangoHud.revision}";
    src = npins.MangoHud;
  };
  package = mangohud.override {
    mangohud32 = pkgs.pkgsi686Linux.mangohud.overrideAttrs {
      version = "0-unstable-${substring 0 8 npins.MangoHud.revision}";
      src = npins.MangoHud;
    };
    gamescopeSupport = config.cfg.programs.gamescope.enable;
    nvidiaSupport = config.cfg.hardware.nvidia.enable;
  };
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
      packages = [package];
      xdg.config.files = {
        "MangoHud/MangoHud.conf".text = ''
          blacklist=mpv
          font_size=19
          fps_limit=${toString fpsLimit},0
          gl_vsync=0
          preset=0,1,2
          toggle_hud=Shift_R+F12
          toggle_hud_position=Shift_R+F11
          toggle_preset=Shift_R+F10
          vsync=1
        '';
        "MangoHud/presets.conf".text = ''
          [preset 0]
          fps_only
          background_alpha=0
          hud_no_margin

          [preset 1]
          background_alpha=0.3
          hud_no_margin
          gpu_text=GPU
          gpu_stats
          gpu_core_clock
          gpu_mem_clock
          gpu_temp
          gpu_power
          vram
          fps
          frame_timing
          cpu_text=CPU
          cpu_stats
          cpu_mhz
          cpu_temp
          cpu_power
          ram
          present_mode

          [preset 2]
          background_alpha=0.3
          hud_no_margin
          gpu_text=GPU
          gpu_stats
          gpu_core_clock
          gpu_mem_clock
          gpu_temp
          gpu_power
          vram
          fps
          frame_timing
          cpu_text=CPU
          cpu_stats
          core_load
          cpu_temp
          cpu_power
          ram
          present_mode
        '';
      };
    };
  };
}
