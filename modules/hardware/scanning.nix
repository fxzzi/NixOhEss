{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.hardware.scanning;
in {
  options.cfg.hardware.scanning.enable = mkEnableOption "scanning";
  config = mkIf cfg.enable {
    hardware = {
      sane.enable = true;
      sane.extraBackends = [pkgs.sane-airscan];
    };
    services = {
      udev.packages = [pkgs.sane-airscan];
    };
    environment.systemPackages = [pkgs.simple-scan];
    users.users.${config.cfg.core.username}.extraGroups = [
      "scanner"
      "lp"
    ];
  };
}
