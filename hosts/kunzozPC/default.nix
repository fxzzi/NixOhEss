{
  pkgs,
  lib,
  ...
}: {
  system.stateVersion = "25.05";
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
    # tearing and ds don't work on kunzozPC
    render.direct_scanout = lib.mkForce 0;
    general.allow_tearing = lib.mkForce 0;
  };
}
