{pkgs, ...}: {
  system.stateVersion = "25.05";
  imports = [
    ./hardware-configuration.nix
    ./options.nix
  ];
  hj = {
    packages = with pkgs; [
      qbittorrent-enhanced
      telegram-desktop
    ];
  };
}
