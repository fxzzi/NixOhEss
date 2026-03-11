{
  pkgs,
  pins,
  inputs',
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
      cemu
      # stremio-linux-shell
      inputs'.azzipkgs.packages.stremio-linux-shell-rewrite-git
      (callPackage "${pins.creamlinux}" {})
    ];
    xdg.config.files."hypr/hyprland.conf" = {
      value = {
        "monitorv2[desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 23080B004543]" = {
          # this monitor is weird and has a 4k60 downscale mode.
          # highrr will prefer the mode with highest rr, then highest res
          # so effectively 1440p170
          mode = "highrr";
          # bad hdr
          supports_hdr = -1;
          # this monitor does support 10bit, but only at 120Hz and lower.
          supports_wide_color = -1;
        };
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
  services.flatpak.enable = true;
}
