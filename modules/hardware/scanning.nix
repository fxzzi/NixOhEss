{
  pkgs,
  user,
  config,
  lib,
  ...
}: {
  options.cfg.hardware.scanning.enable = lib.mkEnableOption "scanning";
  config = lib.mkIf config.cfg.hardware.scanning.enable {
    hardware = {
      sane.enable = true;
      sane.extraBackends = [pkgs.sane-airscan];
    };
    services = {
      udev.packages = [pkgs.sane-airscan];
    };
    environment.systemPackages = [pkgs.simple-scan];
    users.users.${user}.extraGroups = [
      "scanner"
      "lp"
    ];
  };
}
