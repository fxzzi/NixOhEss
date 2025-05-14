{
  pkgs,
  lib,
  config,
  ...
}: {
  options.cfg.music.extraApps.enable = lib.mkEnableOption "extra music apps";
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
