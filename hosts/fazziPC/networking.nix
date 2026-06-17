{
  networking = {
    useDHCP = false;
    defaultGateway = {
      interface = "enp6s0";
      address = "192.168.0.1";
    };
    interfaces.enp6s0 = {
      ipv4.addresses = [
        {
          address = "192.168.0.46"; # Set a fixed local IP
          prefixLength = 24;
        }
      ];
    };
    firewall = let
      allowedPorts = [
        6881 # qbittorrent
        2234 # slsk / nicotine+
        25565 # minecraft
      ];
    in {
      allowedTCPPorts = allowedPorts;
      allowedUDPPorts = allowedPorts;
    };
  };
}
