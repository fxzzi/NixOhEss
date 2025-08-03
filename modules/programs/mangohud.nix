{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf concatStringsSep lists attrsets strings isBool;
  inherit (builtins) toString typeOf;
  cfg = config.cfg.programs.mangohud;

  renderOption = option:
    rec {
      int = toString option;
      float = int;
      path = int;
      bool = "0"; # "on/off" opts are disabled with `=0`
      string = option;
      list = concatStringsSep "," (lists.forEach option toString);
    }
    .${
      typeOf option
    };

  renderLine = k: v: (
    if isBool v && v
    then k
    else "${k}=${renderOption v}"
  );
  renderSettings = attrs: strings.concatStringsSep "\n" (attrsets.mapAttrsToList renderLine attrs) + "\n";

  fpsLimit = let
    rr = cfg.refreshRate;
  in
    if config.programs.hyprland.settings.misc.vrr == 0
    then rr
    # NOTE:https://old.reddit.com/r/nvidia/comments/1lokih2/putting_misconceptions_about_optimal_fps_caps/
    else (rr - (rr * rr / 3600));
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
      packages = [pkgs.mangohud];
      xdg.config.files = {
        "MangoHud/MangoHud.conf".text = renderSettings {
          preset = "0,1,2";
          fps_limit = "${toString fpsLimit},0"; # few below refresh rate (vrr) or unlimited
          toggle_hud = "Shift_R+F12";
          toggle_hud_position = "Shift_R+F11";
          toggle_preset = "Shift_R+F10";
          font_size = 19;
          vsync = 1; # disable vulkan vsync
          gl_vsync = 0; # disable opengl vsync
          blacklist = [
            "mpv"
          ];
        };
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
