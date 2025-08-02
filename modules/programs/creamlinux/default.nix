{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  creamlinux = inputs.creamlinux.packages.${pkgs.system}.default;
in {
  options.cfg.gaming = {
    creamlinux.enable = lib.mkEnableOption "creamlinux";
  };
  config = lib.mkIf config.cfg.gaming.creamlinux.enable {
    hj = {
      packages = [
        creamlinux
      ];
    };
  };
}
