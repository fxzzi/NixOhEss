{
  lib,
  config,
  user,
  ...
}: {
  options.netConfig.networkmanager.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the basic networkmanager configuration";
  };
  config = lib.mkIf config.netConfig.networkmanager.enable {
    # environment.systemPackages = with pkgs; [
    #   networkmanagerapplet
    # ];
    programs.nm-applet.enable = true;
    networking = {
      networkmanager = {
        enable = true;
        wifi = {
          powersave = true;
        };
        dns = "systemd-resolved";
      };
    };
    users.users.${user} = {
      extraGroups = ["networkmanager"];
    };
  };
}
