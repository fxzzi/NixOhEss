{ ... }:
{
  networking.hostName = "fazziGO";
	services.upower = {
		enable = true;
	};
  imports = [
    ../global
		./hardware-configuration.nix
    ./amdgpu
    ./networking
  ];
}
