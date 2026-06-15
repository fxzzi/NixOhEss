{
  pkgs,
  inputs,
  self,
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
      losange
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
      # inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.flac2vorbis
      # inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.flac2opus
    ];
  };

  # set resolutions early to avoid modeset when launching hyprland
  hardware.display.outputs = {
    "DP-3".mode = "2560x1440-30@280";
    "DP-2".mode = "2560x1440-24@170";
  };

  # icc files used in Hyprland
  age.secrets = {
    m27q = {
      file = "${self}/secrets/mub-M27Q_v1.icm.age";
      mode = "744";
    };
    mo27q28g = {
      file = "${self}/secrets/tft-gigabyte_mo27q28g.icm.age";
      mode = "744";
    };
  };

  # fazziPC has a WOLED main monitor with subpixel layout RGWB,
  # and a secondary monitor of layout BGR. Therefore we shouldn't
  # use subpixel rendering.
  fonts.fontconfig.subpixel.rgba = "none";

  hardware.audient-evo.config = {
    monitor = 65;
    input1 = {
      gain = 45;
      phantom = true;
    };
  };
}
