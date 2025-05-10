{pkgs, ...}: {
  system.stateVersion = "25.05";
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "16G";
    MemoryMax = "24G";
  };
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./fancontrol.nix
  ];
  cfg = import ./options.nix;
  # host specific packages
  hj.packages = with pkgs; [
    qbittorrent-enhanced
    telegram-desktop
    godot3
    losslesscut-bin
    qpwgraph
  ];
}
