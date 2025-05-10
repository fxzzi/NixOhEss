{
  lib,
  config,
  ...
}: {
  options.cfg.networking.enable = lib.mkEnableOption "networking";
  config = lib.mkIf config.cfg.networking.enable {
    networking = {
      # may want to override if using fixed IP. See: fazziPC
      useDHCP = lib.mkDefault true;
      dhcpcd.enable = lib.mkDefault true;

      # Use quad9 DNS
      nameservers = [
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
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
