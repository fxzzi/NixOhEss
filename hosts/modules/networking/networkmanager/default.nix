{
  lib,
  config,
  user,
  ...
}: {
  options.cfg.netConfig.networkmanager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the basic networkmanager configuration";
    };
    powersaving.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables powersaving for wifi, likely for laptops.";
    };
  };
  config = lib.mkIf config.cfg.netConfig.networkmanager.enable {
    programs.nm-applet.enable = true;
    networking = {
      networkmanager = {
        enable = true;
        wifi = {
          powersave = config.cfg.netConfig.networkmanager.powersaving.enable;
        };
        dns = "systemd-resolved";
      };
    };
    users.users.${user} = {
      extraGroups = ["networkmanager"];
    };
  };
}
