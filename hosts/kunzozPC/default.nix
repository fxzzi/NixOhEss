{
  inputs',
  pkgs,
  pins,
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
      sgdboop
      inputs'.azzipkgs.packages.stremio-linux-shell-git
      (callPackage "${pins.creamlinux}" {})
    ];
    xdg.config.files."hypr/hyprland.conf" = {
      value = {
        # tearing and ds don't work on kunzozPC
        render.direct_scanout = 0;
        general.allow_tearing = 0;
      };
    };
  };
  hardware.display = {
    outputs."DP-3".mode = "2560x1440@170";
  };
  networking.firewall = {
    # minecraft
    allowedUDPPorts = [25565];
    allowedTCPPorts = [25565];
  };
  services.lact = {
    enable = true;
    # settings = {};
  };
}
