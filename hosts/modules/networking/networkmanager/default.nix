{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.netConfig.networkmanager.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the basic networkmanager configuration";
  };
  config = lib.mkIf config.netConfig.networkmanager.enable {
    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
    networking = {
      networkmanager = {
        enable = true;
        # powersaving for laptop
        wifi.powersave = true;
        dns = "systemd-resolved";
      };
    };
  };
}
