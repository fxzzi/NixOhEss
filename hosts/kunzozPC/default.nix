{
  pkgs,
  lib,
  ...
}: {
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
  programs.hyprland.settings = {
    # this combo works for kunzozPC, idk y
    render.direct_scanout = lib.mkForce 0;
    general.allow_tearing = lib.mkForce 0;
    misc.vrr = lib.mkForce 2;
  };
}
