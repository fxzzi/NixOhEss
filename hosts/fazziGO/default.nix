{ ... }:
{
  networking.hostName = "fazziGO";
  imports = [
    ../global
		./hardware-configuration.nix
    ./networking
  ];
}
