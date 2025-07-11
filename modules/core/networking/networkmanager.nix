{
  lib,
  config,
  user,
  pkgs,
  ...
}: {
  options.cfg.networking.networkmanager = {
    enable = lib.mkEnableOption "NetworkManager";
    powersaving.enable = lib.mkEnableOption "powersaving";
  };
  config = lib.mkIf config.cfg.networking.networkmanager.enable {
    programs.nm-applet.enable = true; # enable the nice lil applet
    networking = {
      dhcpcd.enable = false; # networkmanager uses its own dhcp client
      networkmanager = {
        enable = true;
        wifi = {
          powersave = config.cfg.networking.networkmanager.powersaving.enable;
        };
        dns = "systemd-resolved";
        plugins = with pkgs; [
          networkmanager-openvpn
        ];
      };
    };
    users.users.${user} = {
      extraGroups = ["networkmanager"];
    };
  };
}
