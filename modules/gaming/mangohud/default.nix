{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;

  renderOption = option:
    rec {
      int = toString option;
      float = int;
      path = int;
      bool = "0"; # "on/off" opts are disabled with `=0`
      string = option;
      list = lib.concatStringsSep "," (lib.lists.forEach option toString);
    }
    .${
      builtins.typeOf option
    };

  renderLine = k: v: (
    if lib.isBool v && v
    then k
    else "${k}=${renderOption v}"
  );
  renderSettings = attrs: lib.strings.concatStringsSep "\n" (lib.attrsets.mapAttrsToList renderLine attrs) + "\n";
in {
  options.cfg.gaming.mangohud = {
    enable = lib.mkEnableOption "mangohud";
    enableSessionWide = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable MangoHud for all Vulkan apps.";
    };
  };
  config = lib.mkIf config.cfg.gaming.mangohud.enable {
    environment.sessionVariables = lib.mkIf config.cfg.gaming.mangohud.enableSessionWide {
      "MANGOHUD" = "1";
    };
    hj = {
      packages = [pkgs.mangohud];
      files = {
        ".config/MangoHud/MangoHud.conf".text = renderSettings {
          preset = "0,1";
          fps_limit = "167,0"; # few below refresh rate (vrr) or unlimited
          toggle_hud = "Shift_R+F12";
          toggle_hud_position = "Shift_R+F11";
          toggle_preset = "Shift_R+F10";
          blacklist = "mpv";
        };
        ".config/MangoHud/presets.conf".text = ''
          [preset 0]
          fps_only
          background_alpha=0

          hud_no_margin
          font_size=20

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
        '';
      };
    };
  };
}
