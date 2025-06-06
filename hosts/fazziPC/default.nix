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
    losslesscut-bin
    qpwgraph
  ];
  programs.hyprland.settings = {
    monitor = [
      "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 20120B000001, 2560x1440@170,0x0, 1"
      "desc:Philips, 1920x1080@75,auto-center-left, 1"
    ];
  };
}
