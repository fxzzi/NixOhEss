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
    creamlinux.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables creamlinux-installer.";
    };
  };
  config = lib.mkIf config.cfg.gaming.creamlinux.enable {
    home.packages = [
      creamlinux
    ];
  };
}
