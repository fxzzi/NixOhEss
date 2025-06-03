{
  user,
  pkgs,
  ...
}: {
  config = {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.${user}.enableGnomeKeyring = true;
    systemd.user.services.gnome-keyring = {
      enable = true;
      description = "GNOME Keyring";
      partOf = ["graphical-session-pre.target"];
      wantedBy = ["graphical-session-pre.target"];
      serviceConfig = {
        Type = "simple";
        Restart = "on-abort";
        ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=pkcs11,secrets,ssh";
      };
    };
    environment.sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
    };
  };
}
