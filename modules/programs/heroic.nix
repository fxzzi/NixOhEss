{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.heroic;
in {
  options.cfg.programs.heroic.enable = mkEnableOption "heroic";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.heroic
      ];

      files = {
        ".config/heroic/tools/proton/GE-Proton" = mkIf config.cfg.programs.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
      };
    };
  };
}
