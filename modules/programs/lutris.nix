{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.programs.lutris.enable = lib.mkEnableOption "lutris";
  config = lib.mkIf config.cfg.programs.lutris.enable {
    hj = {
      packages = with pkgs; [
        lutris
      ];

      files = {
        ".local/share/lutris/runners/proton/GE-Proton" = lib.mkIf config.cfg.programs.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
      };
    };
  };
}
