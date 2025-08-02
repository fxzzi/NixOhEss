{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.gaming.lutris.enable = lib.mkEnableOption "lutris";
  config = lib.mkIf config.cfg.gaming.lutris.enable {
    hj = {
      packages = with pkgs; [
        lutris
      ];

      files = {
        ".local/share/lutris/runners/proton/GE-Proton" = lib.mkIf config.cfg.gaming.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
      };
    };
  };
}
