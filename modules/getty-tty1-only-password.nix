{ pkgs, ... }:
{
  # https://gist.github.com/caadar/7884b1bf16cb1fc2c7cde33d329ae37f
  # https://github.com/NixOS/nixpkgs/issues/81552
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig = {
      ExecStart = [
        "" # override upstream default with an empty ExecStart
        "@${pkgs.utillinux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login --skip-login -o '-p -- faaris'--noclear %I $TERM"
      ];
    };
  };
}
