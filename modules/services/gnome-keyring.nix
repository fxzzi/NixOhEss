{ self, ... }: {
  config = {
    services.gnome.gnome-keyring.enable = true;
    # actually start the secrets and pkcs11 daemons
    # these are normally in xdg autostart but we don't use those.
    hj.systemd.services.gnome-keyring = self.lib.mkGraphicalService {
      description = "GNOME Keyring Daemon";
      # run from wrapper for correct permissions
      exec = "/run/wrappers/bin/gnome-keyring-daemon --start --foreground --components=secrets,pkcs11";
    };
  };
}
