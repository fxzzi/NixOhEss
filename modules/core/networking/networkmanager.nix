{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.core.networkmanager;
in {
  options.cfg.core.networkmanager = {
    enable = mkEnableOption "NetworkManager";
  };
  config = mkIf cfg.enable {
    programs.nm-applet.enable = true; # enable the nice lil applet
    networking = {
      networkmanager = {
        enable = true;
        wifi.powersave = config.cfg.core.isLaptop;
        dns = "systemd-resolved";
        dhcp = "dhcpcd";
        plugins = with pkgs; [
          networkmanager-openvpn
        ];
      };
    };
    users.users.${config.cfg.core.username} = {
      extraGroups = ["networkmanager"];
    };
  };
}
