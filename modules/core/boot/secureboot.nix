{
  sources,
  lib,
  pkgs,
  config,
  ...
}: let
  lanzaboote = import (sources.lanzaboote + "/default-npins.nix") {
    sources = null;
    inherit (sources) crane nixpkgs rust-overlay;
  };
in {
  options.cfg.secureboot.enable = lib.mkEnableOption "secureboot";
  config = lib.mkIf config.cfg.secureboot.enable {
    environment.systemPackages = with pkgs; [
      sbctl
      tpm2-tss
    ];
    boot = {
      initrd.systemd.tpm2.enable = true;
      # lanzaboote replaces systemd-boot, so disable it with mkForce here.
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  };
  imports = [lanzaboote.nixosModules.lanzaboote];
}
