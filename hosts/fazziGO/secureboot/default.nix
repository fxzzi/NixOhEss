{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
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
}
