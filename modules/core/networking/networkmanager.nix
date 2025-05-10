{
  lib,
  config,
  user,
  ...
}: {
  options.cfg.networking.networkmanager = {
    enable = lib.mkEnableOption "";
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
      };
    };
    users.users.${user} = {
      extraGroups = ["networkmanager"];
    };
  };
}
