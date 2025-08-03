{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.lutris;
in {
  options.cfg.programs.lutris.enable = mkEnableOption "lutris";
  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        lutris
      ];

      xdg.data.files."lutris/runners/proton/GE-Proton" = mkIf config.cfg.programs.proton-ge.enable {
        source = pkgs.proton-ge-bin.steamcompattool;
      };
    };
  };
}
