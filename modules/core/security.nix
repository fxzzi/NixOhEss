{user, ...}: {
  config = {
    security = {
      polkit.enable = true;
      pam.services.${user}.enableGnomeKeyring = true;
      sudo-rs = {
        enable = true;
        execWheelOnly = true;
        # show asterisks when typing password
        configFile = ''
          Defaults pwfeedback
          Defaults env_keep += "EDITOR PATH DISPLAY"
        '';
      };
    };
    services.gnome.gnome-keyring.enable = true;
  };
}
