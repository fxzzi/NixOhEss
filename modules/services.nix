{ config, pkgs, lib, inputs, ... }:

{
  # List services that you want to enable:
  services = {
    printing.enable = true;
    tumbler.enable = true; # Thunar thumbnailer
    # gnome.gnome-keyring.enable = true;
    gvfs.enable = true; # Enable gvfs for stuff like trash, mtp
    gvfs.package = pkgs.gvfs; # Set to gvfs instead of gnome gvfs
		scx = {
			enable = true;
			scheduler = "scx_lavd";
			package = pkgs.scx.rustscheds;
		};
  };

  security.polkit.enable = true; # Enable polkit for root access in GUI apps
  security.rtkit.enable = true; # Enable RTKit service for Pipewire priority
  # security.pam.services.faaris.enableGnomeKeyring = true; # Enable gnome keyring for user
  security.pam.sshAgentAuth.enable = true;
}
