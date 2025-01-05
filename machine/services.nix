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
  security.pam.sshAgentAuth.enable = true;

	services.udev.extraRules = ''
# Wooting One Legacy
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

# Wooting One update mode 
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess"

# Wooting Two Legacy
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

# Wooting Two update mode  
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess"

# Generic Wootings
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", TAG+="uaccess"
	'';
}
