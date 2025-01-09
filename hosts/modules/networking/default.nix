{
  lib,
  config,
  ...
}: {
  options.netConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables basic network configuration, like enabling resolved and cloudflare DNS.";
  };
  config = lib.mkIf config.netConfig.enable {
    networking = {
      useDHCP = false;
      dhcpcd.enable = false;
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
      ]; # Use cloudflare DNS
      firewall.enable = true;
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
