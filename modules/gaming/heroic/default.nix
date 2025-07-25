{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.gaming.heroic.enable = lib.mkEnableOption "heroic";
  config = lib.mkIf config.cfg.gaming.heroic.enable {
    hj = {
      packages = [
        pkgs.heroic
      ];

      files = {
        ".config/heroic/tools/proton/GE-Proton" = lib.mkIf config.cfg.gaming.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
      };
    };
  };
}
