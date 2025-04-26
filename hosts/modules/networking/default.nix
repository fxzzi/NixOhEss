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
      # may want to override if using fixed IP. See: fazziPC
      useDHCP = lib.mkDefault true;
      dhcpcd.enable = lib.mkDefault true;

      # Use cloudflare DNS
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      firewall = {
        enable = true;
        # allow ports for:
        # - qbitorrent
        # - soulseek / nicotine+
        allowedTCPPorts = [6881 2234];
        allowedUDPPorts = [6881 2234];
      };
    };
    services.resolved = {
      enable = true;
      dnsovertls = "opportunistic";
    };
  };
  imports = [
    ./mediamtx
    ./networkmanager
  ];
}
