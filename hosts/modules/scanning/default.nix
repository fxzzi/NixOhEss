{
  pkgs,
  user,
  config,
  lib,
  ...
}: {
  options.cfg.scanning.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables sane and airscan for using scanners";
  };
  config = lib.mkIf config.cfg.scanning.enable {
    hardware = {
      sane.enable = true;
      sane.extraBackends = [pkgs.sane-airscan];
    };
    services = {
      udev.packages = [pkgs.sane-airscan];
      avahi = {
        enable = true;
        nssmdns = true;
        openFirewall = true;
      };
    };
    environment.systemPackages = [pkgs.simple-scan];
    users.users.${user}.extraGroups = [
      "scanner"
      "lp"
    ];
  };
}
