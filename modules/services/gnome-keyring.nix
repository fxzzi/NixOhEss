{pkgs, ...}: {
  config = {
    security.pam.services.greetd.enableGnomeKeyring = true;
    services = {
      gnome.gnome-keyring.enable = true;
      dbus.enable = true;
      dbus.packages = [pkgs.gcr];
    };
  };
}
