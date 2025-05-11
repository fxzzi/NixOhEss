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
    systemd.user.services.nm-applet = {
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY"; # Only start if WAYLAND_DISPLAY env var is set
      };
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
