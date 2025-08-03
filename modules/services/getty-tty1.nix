{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.cfg.services.getty-tty1;
in {
  options.cfg.services.getty-tty1.onlyPassword = mkOption {
    type = types.bool;
    default = false;
    description = "Skip asking for the username, and only ask for the password on tty1.";
  };
  config = mkIf cfg.onlyPassword {
    # Skip username only for tty1
    systemd.services."getty@tty1" = {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = [
        ""
        "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login -o '-p -- ${config.cfg.core.username}' --noclear --skip-login %I $TERM"
      ];
    };
  };
}
