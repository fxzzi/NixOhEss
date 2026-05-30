{
  pkgs,
  self,
  inputs,
  ...
}: {
  system.stateVersion = "25.05";
  # host specific packages
  hj = {
    packages = with pkgs; [
      qbittorrent
      losslesscut-bin
      steamguard-cli
      picard
      rsgain
      olympus
      nicotine-plus
      sgdboop
      cemu
      dolphin-emu
      nvtopPackages.nvidia
      yt-dlp
      eden
      # stremio-linux-shell
      (retroarch.withCores (cores:
        with cores; [
          bsnes
          beetle-psx-hw
          genesis-plus-gx
          melonds
          mupen64plus
        ]))
      self.packages.${pkgs.stdenv.hostPlatform.system}.transcode
      inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.losange
      inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.flac2vorbis
      inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.flac2opus
    ];
  };

  # set resolutions early to avoid modeset when launching hyprland
  hardware.display.outputs = {
    "DP-3".mode = "2560x1440-30@280";
    "DP-2".mode = "2560x1440-24@170";
  };
  # fazziPC has a WOLED main monitor with subpixel layout RGWB,
  # and a secondary monitor of layout BGR. Therefore we shouldn't
  # use subpixel rendering.
  fonts.fontconfig.subpixel.rgba = "none";
}
