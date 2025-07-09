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
  };
  services.blueman.enable = true;
}
