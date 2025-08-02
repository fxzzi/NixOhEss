{
  lib,
  config,
  hostName,
  ...
}: {
  options.cfg.networking.enable = lib.mkEnableOption "networking";
  config = lib.mkIf config.cfg.networking.enable {
    networking = {
      inherit hostName;
      # may want to override if using fixed IP. See: fazziPC
      useDHCP = lib.mkDefault true;
      dhcpcd.enable = lib.mkDefault true;

      # Use Cloudflare DNS
      nameservers = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
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
  imports = [
    ./mediamtx.nix
    ./networkmanager.nix
  ];
}
