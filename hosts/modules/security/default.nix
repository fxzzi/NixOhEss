{
  lib,
  config,
  user,
  ...
}: {
  options.cfg.security.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables gnome-keyring, polkit, and sudo configurations";
  };
  config = lib.mkIf config.cfg.security.enable {
    security = {
      polkit.enable = true;
      pam.services.${user}.enableGnomeKeyring = true;
      sudo = {
        enable = true;
        # show asterisks when typing password
        extraConfig = ''
          Defaults pwfeedback
          Defaults env_keep += "EDITOR PATH DISPLAY"
        '';
      };
    };
    services.gnome.gnome-keyring.enable = true;
  };
}
