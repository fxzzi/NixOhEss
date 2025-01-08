{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  options.tty1-autologin = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Overrides getty@tty1 to autologin.";
  };
  config = lib.mkIf config.tty1-autologin {
    # https://gist.github.com/caadar/7884b1bf16cb1fc2c7cde33d329ae37f
    # https://github.com/NixOS/nixpkgs/issues/81552
    systemd.services."getty@tty1" = {
      overrideStrategy = "asDropin";
      serviceConfig = {
        ExecStart = [
          "" # override upstream default with an empty ExecStart
          "@${pkgs.utillinux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login --autologin ${user} --noclear %I $TERM"
        ];
      };
    };
  };
}
