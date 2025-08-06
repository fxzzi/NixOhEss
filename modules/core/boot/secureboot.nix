{
  lib,
  pkgs,
  config,
  npins,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.cfg.core.boot.secureboot;
  compat = import npins.flake-compat;
  lanzaboote =
    (compat.load {
      src = npins.lanzaboote;

      replacements = {
        # Pass your nixpkgs to lanzaboote as an input. We have
        # to pass it as a flake as well.
        nixpkgs = compat.load {src = inputs.nixpkgs;};
      };
    }).outputs;
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
  imports = [lanzaboote.nixosModules.lanzaboote];
}
