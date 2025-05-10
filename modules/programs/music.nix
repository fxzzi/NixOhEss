{
  pkgs,
  lib,
  config,
  ...
}: {
  options.cfg.music.extraApps.enable = lib.mkEnableOption "extraApps";
  config = lib.mkIf config.cfg.music.extraApps.enable {
    hj = {
      packages = with pkgs; [
        nicotine-plus
        picard
        rsgain
      ];
    };
  };
}
