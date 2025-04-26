{
  config = {
    networking = {
      useDHCP = false;
      dhcpcd.enable = false;
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
