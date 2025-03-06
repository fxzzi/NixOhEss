{
  lib,
  config,
  user,
  ...
}: {
  options.cfg.security.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables polkit and gnome keyring.";
  };
  config = lib.mkIf config.cfg.security.enable {
    security = {
      polkit.enable = true;
      pam.services.${user}.enableGnomeKeyring = true;
    };
    services.gnome.gnome-keyring.enable = true;
  };
}
