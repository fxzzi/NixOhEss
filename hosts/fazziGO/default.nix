{pkgs, ...}: {
  system.stateVersion = "25.05";
  imports = [
    ./hardware-configuration.nix
    ./options.nix
  ];
  hj = {
    packages = with pkgs; [
      telegram-desktop
      qpwgraph
    ];
  };
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false; # i don't use bluetooth much so disable it by default
  };
  services.blueman.enable = true;
}
