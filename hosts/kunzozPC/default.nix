{
  pkgs,
  lib,
  npins,
  ...
}: {
  system.stateVersion = "25.05";
  imports = [
    ./hardware-configuration.nix
    ./gtkBookmarks.nix
    ./options.nix
  ];
  hj = {
    packages = with pkgs; [
      losslesscut-bin
      qbittorrent-enhanced
      nvtopPackages.amd
      stremio
      sgdboop
      (callPackage npins.creamlinux {})
    ];
    xdg.config.files."hypr/hyprland.conf" = {
      value = {
        # tearing and ds don't work on kunzozPC
        render.direct_scanout = lib.mkForce 0;
        general.allow_tearing = lib.mkForce 0;
        misc.vrr = lib.mkForce 2;
      };
    };
  };

  hardware.display = {
    outputs."DP-3" = {
      mode = "2560x1440@170";
    };
  };
  networking.firewall = {
    # minecraft
    allowedUDPPorts = [25565];
    allowedTCPPorts = [25565];
  };
}
