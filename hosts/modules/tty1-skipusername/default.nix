{
  pkgs,
  lib,
  config,
  user,
  ...
}: {
  options.cfg.tty1-skipusername = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Overrides getty@tty1 to autologin.";
  };
  config = lib.mkIf config.cfg.tty1-skipusername {
    # Skip username only for tty1
    systemd.services."getty@tty1" = {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = [
        ""
        "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login -o '-p -- ${user}' --noclear --skip-login %I $TERM"
      ];
    };
  };
}
