{
  lib,
  config,
  ...
}: {
  options.cfg.netConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables basic network configuration, like enabling resolved and cloudflare DNS.";
  };
  config = lib.mkIf config.cfg.netConfig.enable {
    networking = {
      useDHCP = false;
      dhcpcd.enable = false;
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ]; # Use cloudflare DNS
      firewall = {
        enable = true;
        allowedTCPPorts = [6881 2234]; # qbittorrent and soulseek
        allowedUDPPorts = [6881 2234];
      };
    };
    services.resolved = {
      enable = true;
      dnsovertls = "true";
    };
  };
  imports = [
    ./desktopFixedIP
    ./mediamtx
    ./networkmanager
  ];
}
