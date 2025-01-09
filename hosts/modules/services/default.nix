{
  config,
  pkgs,
  lib,
user,
  ...
}: {
  options.services.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables basic services for thunar, polkit, and printing";
  };
  options.services.wootingRules.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Adds extra udev rules to allow configuration of wooting keyboards.";
  };
  config = {
    services = {
      printing.enable = true;
      tumbler.enable = true; # Thunar thumbnailer
      gvfs.enable = true; # Enable gvfs for stuff like trash, mtp
      gvfs.package = pkgs.gvfs; # Set to gvfs instead of gnome gvfs
    };

    security.polkit.enable = true; # Enable polkit for root access in GUI apps
		security.pam.services.${user}.enableGnomeKeyring = true;
		services.gnome.gnome-keyring.enable = true;

    services.udev.extraRules = lib.mkIf config.services.wootingRules.enable ''
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
  };
}
