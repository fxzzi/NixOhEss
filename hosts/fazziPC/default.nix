{ ... }:
{
  networking.hostName = "fazziPC";
	programs.gamemode.enable = true;
  imports = [
    ../global
    ./hardware-configuration.nix
    ./boot
    ./steam
    ./nvidia
    ./fancontrol
    ./networking
  ];
}
