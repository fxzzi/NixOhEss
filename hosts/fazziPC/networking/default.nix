{ ... }:
{
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
    firewall = {
      enable = true;
      allowedTCPPorts = [
        25564
        25565
        4200
      ];
      allowedUDPPorts = [
        25564
        25565
        4200
      ];
    };
  };
  services.mediamtx = {
    enable = true;
    settings = {
      webrtc = true;
      webrtcAddress = ":4200";
      webrtcLocalUDPAddress = ":4200";
      webrtcAdditionalHosts = [ ];
      paths = {
        all_others = { };
      };
    };
  };
}
