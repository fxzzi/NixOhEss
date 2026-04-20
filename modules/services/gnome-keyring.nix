_: {
  config = {
    services.gnome.gnome-keyring.enable = true;
    # actually start the secrets and pkcs11 daemons
    # these are normally in xdg autostart but we don't use those.
    hj.systemd.services.gnome-keyring = {
      description = "GNOME Keyring Daemon";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        # run from wrapper for correct permissions
        ExecStart = "/run/wrappers/bin/gnome-keyring-daemon --start --foreground --components=secrets,pkcs11";
      };
    };
  };
}
