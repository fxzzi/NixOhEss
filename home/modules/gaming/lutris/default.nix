{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.gaming.lutris.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Adds the lutris game launcher to configuration";
  };
  options.cfg.gaming.lutris.protonge.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.cfg.gaming.lutris.enable;
    defaultText = "config.cfg.gaming.lutris.enable";
    description = "Enable proton-ge-bin for use in lutris";
  };

  config = lib.mkIf config.cfg.gaming.lutris.enable {
    home.packages = with pkgs; [
      lutris
    ];
    xdg = {
      dataFile = {
        "lutris/runners/proton/GE-Proton" = lib.mkIf config.cfg.gaming.lutris.protonge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
      };
    };
  };
}
