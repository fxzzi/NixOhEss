{pkgs, ...}: {
  system.stateVersion = "25.05";
  # brother has 64gb of ram for reasons beyond my understanding
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "42G";
    MemoryMax = "48G";
  };
  imports = [
    ./hardware-configuration.nix
    ./gtkBookmarks.nix
  ];
  cfg = import ./options.nix;
  hj = {
    packages = with pkgs; [
      losslesscut-bin
      qbittorrent-enhanced
    ];
  };
}
