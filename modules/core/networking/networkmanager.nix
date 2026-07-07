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
        connectionConfig = {
          # don't use router advertised dns
          "ipv4.ignore-auto-dns" = true;
          "ipv6.ignore-auto-dns" = true;
        };
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
