{ ... }:
{
  networking.hostName = "fazziGO";
	services.upower = {
		enable = true;
	};
	programs.light.enable = true;
  imports = [
    ../global
		./hardware-configuration.nix
    ./amdgpu
    ./networking
		./secureboot
  ];
}
