{
  pkgs,
  lib,
  pins,
  inputs,
  ...
}: let
  lanzaboote = import pins.lanzaboote {
    inherit pkgs;
    crane = inputs.crane.mkLib pkgs;
  };
in {
  imports = [lanzaboote.nixosModules.lanzaboote];

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
    pkgs.tpm2-tss
  ];

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
