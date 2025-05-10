{pkgs, ...}: {
  system.stateVersion = "25.05";
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "6G";
    MemoryMax = "8G";
  };
  imports = [
    ./hardware-configuration.nix
    ./options.nix
  ];
  hj = {
    packages = with pkgs; [
      qbittorrent-enhanced
      telegram-desktop
      godot3
    ];
  };
}
