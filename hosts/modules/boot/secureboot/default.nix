{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  options.secureboot.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables secure boot and tpm2 unlock with sbctl and lanzaboote";
  };
  config = lib.mkIf config.secureboot.enable {
    environment.systemPackages = with pkgs; [
      sbctl
      tpm2-tss
    ];
    boot = {
      initrd.systemd.enable = true;
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  };
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];
}
