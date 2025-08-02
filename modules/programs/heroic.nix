{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.programs.heroic.enable = lib.mkEnableOption "heroic";
  config = lib.mkIf config.cfg.programs.heroic.enable {
    hj = {
      packages = [
        pkgs.heroic
      ];

      files = {
        ".config/heroic/tools/proton/GE-Proton" = lib.mkIf config.cfg.programs.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
      };
    };
  };
}
