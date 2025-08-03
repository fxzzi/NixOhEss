{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.cfg.core.boot.secureboot;
in {
  options.cfg.core.boot.secureboot.enable = mkEnableOption "secureboot";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sbctl
      tpm2-tss
    ];
    boot = {
      initrd.systemd.tpm2.enable = true;
      # lanzaboote replaces systemd-boot, so disable it with mkForce here.
      loader.systemd-boot.enable = mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  };
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];
}
