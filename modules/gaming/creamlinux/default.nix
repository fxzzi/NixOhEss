{
  config,
  lib,
  pkgs,
  sources,
  ...
}: {
  options.cfg.gaming = {
    creamlinux.enable = lib.mkEnableOption "creamlinux";
  };
  config = lib.mkIf config.cfg.gaming.creamlinux.enable {
    hj = {
      packages = [
        (pkgs.callPackage "${sources.creamlinux}" {})
      ];
    };
  };
}
