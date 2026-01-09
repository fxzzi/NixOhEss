{
  self',
  pkgs,
  ...
}: {
  system.stateVersion = "25.05";
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./fancontrol.nix
    ./gtkBookmarks.nix
    ./options.nix
  ];
  # host specific packages
  hj = {
    packages = with pkgs; [
      qbittorrent-enhanced
      # telegram-desktop
      losslesscut-bin
      steamguard-cli
      picard
      rsgain
      olympus
      nicotine-plus
      # sgdboop
      cemu
      dolphin-emu
      nvtopPackages.nvidia
      yt-dlp
      (retroarch.withCores (cores:
        with cores; [
          bsnes
          beetle-psx-hw
          genesis-plus-gx
          melonds
          mupen64plus
        ]))
      onlyoffice-desktopeditors
      processing
      logisim-evolution
      rars
      vscodium
      (jetbrains.idea-oss.override {
        vmopts = "-Dawt.toolkit.name=WLToolkit";
      })
      self'.packages.transcode
      self'.packages.stremio-linux-shell-rewrite
      self'.packages.eden
      self'.packages.flac2vorbis
    ];

    # idk ds is broken
    xdg.config.files."hypr/hyprland.conf".value.render.direct_scanout = 0;
  };
  # set resolutions early to avoid modeset when launching hyprland
  hardware.display.outputs = {
    "DP-3".mode = "2560x1440-30@280";
    "DP-2".mode = "2560x1440-30@120";
  };
  # fazziPC has a WOLED main monitor with subpixel layout RGWB,
  # and a secondary monitor of layout BGR. Therefore we shouldn't
  # use subpixel rendering.
  fonts.fontconfig.subpixel.rgba = "none";
}
