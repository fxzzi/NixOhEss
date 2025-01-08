{ ... }:
{
  networking.hostName = "fazziPC";

  imports = [
    ../global
    ./hardware-configuration.nix
    ./boot
    ./gaming
    ./nvidia
    ./fancontrol
    ./networking
  ];
}
