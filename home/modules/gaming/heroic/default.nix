{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.gaming.heroic.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the Heroic Games Launcher";
  };
  config = lib.mkIf config.cfg.gaming.heroic.enable {
    home.packages = with pkgs; [
      heroic
    ];
    xdg = {
      configFile = {
        "heroic/tools/proton/GE-Proton" = lib.mkIf config.cfg.gaming.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
      };
    };
  };
}
