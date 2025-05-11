{
  lib,
  config,
  user,
  ...
}: {
  options.cfg.networking.networkmanager = {
    enable = lib.mkEnableOption "NetworkManager";
    powersaving.enable = lib.mkEnableOption "powersaving";
  };
  config = lib.mkIf config.cfg.networking.networkmanager.enable {
    programs.nm-applet.enable = true; # enable the nice lil applet
    # avoid nm-applet starting too early
    systemd.user.services.nm-applet = {
      after = ["graphical-session.target"];
    };
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
