{ config, pkgs, ... }: 
{
  networking = {
    hostName = "faarnixOS";
    dhcpcd.enable = false; # Disable dhcpcd as we use a manual config below
    nameservers = [ "1.1.1.1" "1.0.0.1" ]; # Use cloudflare DNS
    defaultGateway = "192.168.0.1";
    interfaces.enp6s0.ipv4.addresses = [{
      address = "192.168.0.46"; # Set a fixed local IP
      prefixLength = 24;
    }];
  };
}
