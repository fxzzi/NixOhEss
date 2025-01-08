{ inputs, ... }:
{
  networking.hostName = "fazziGO";
  services.power-profiles-daemon.enable = true;
  services.upower = {
    enable = true;
  };
  services.batmon = {
    enable = true;
    settings = {
      batPaths = [
        {
          path = "/sys/class/power_supply/BAT0";
        }
      ];
    };
  };
  programs.light.enable = true;
  imports = [
    inputs.batmon.nixosModules.batmon
    ../global
    ./hardware-configuration.nix
    ./amdgpu
    ./networking
    ./secureboot
  ];
}
