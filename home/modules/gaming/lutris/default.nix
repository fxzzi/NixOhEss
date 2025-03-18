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
  config = lib.mkIf config.cfg.gaming.lutris.enable {
    home.packages = with pkgs; [
      lutris
    ];
    xdg = {
      dataFile = {
        "lutris/runners/proton/GE-Proton" = lib.mkIf config.cfg.gaming.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
      };
    };
  };
}
