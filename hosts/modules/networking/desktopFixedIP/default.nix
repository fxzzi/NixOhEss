{
  lib,
  config,
  ...
}: {
  options.cfg.netConfig.desktopFixedIP.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables my desktop fixed IP config.";
  };
  config = lib.mkIf config.cfg.netConfig.desktopFixedIP.enable {
    networking = {
      defaultGateway = "192.168.0.1";
      interfaces.enp6s0 = {
        ipv4.addresses = [
          {
            address = "192.168.0.46"; # Set a fixed local IP
            prefixLength = 24;
          }
        ];
      };
    };
  };
}
