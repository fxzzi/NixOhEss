{
  lib,
  config,
  hostName,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.cfg.core.networking;
in {
  options.cfg.core.networking.enable = mkEnableOption "networking";
  config = mkIf cfg.enable {
    networking = {
      inherit hostName;
      # may want to override if using fixed IP. See: fazziPC
      useDHCP = mkDefault true;
      dhcpcd.enable = mkDefault true;

      # Use Cloudflare DNS
      nameservers = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
        "2606:4700:4700::1111#one.one.one.one"
        "2606:4700:4700::1001#one.one.one.one"
      ];

      firewall = {
        enable = true;
        # allow ports for:
        # - qbitorrent
        # - soulseek / nicotine+
        allowedTCPPorts = [
          6881
          2234
        ];
        allowedUDPPorts = [
          6881
          2234
        ];
      };
    };
    services.resolved = {
      enable = true;
      dnsovertls = "opportunistic";
    };
  };
}
