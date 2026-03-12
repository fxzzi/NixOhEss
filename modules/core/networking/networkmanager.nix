{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.core.networking.networkmanager;
in {
  options.cfg.core.networking.networkmanager = {
    enable = mkEnableOption "NetworkManager";
  };
  config = mkIf cfg.enable {
    programs.nm-applet.enable = true; # enable the nice lil applet
    networking = {
      dhcpcd.enable = false; # networkmanager uses its own dhcp client
      networkmanager = {
        enable = true;
        wifi = {
          powersave = config.cfg.core.isLaptop;
        };
        dns = "systemd-resolved";
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
