{ ... }:
{
  networking.hostName = "fazziGO";
  services.power-profiles-daemon.enable = true;
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
