{
  self',
  inputs',
  pkgs,
  self,
  config,
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
  age.secrets = {
    m27q = {
      file = "${self}/parts/secrets/mub-M27Q_v1.icm.age";
      mode = "744";
    };
    mo27q28g = {
      file = "${self}/parts/secrets/tft-gigabyte_mo27q28g.icm.age";
      mode = "744";
    };
  };
  # host specific packages
  hj = {
    packages = with pkgs; [
      qbittorrent-enhanced
      telegram-desktop
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
      stremio-linux-shell
      (retroarch.withCores (cores:
        with cores; [
          bsnes
          beetle-psx-hw
          genesis-plus-gx
          melonds
          mupen64plus
        ]))
      self'.packages.transcode
      inputs'.azzipkgs.packages.flac2vorbis
    ];
    xdg.config.files."hypr/hyprland.conf" = {
      value = {
        # main monitor
        "monitorv2[desc:GIGA-BYTE TECHNOLOGY CO. LTD. MO27Q28G 25392F000917]" = {
          mode = "highres";
          bitdepth = 10;
          # use the srgb mode on the monitor for now due to fw issues
          # icc = "${config.age.secrets.mo27q28g.path}";
        };
        # secondary monitor
        "monitorv2[desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 20120B000001]" = {
          mode = "highres";
          position = "auto-center-left";
          # hdr sucks on this monitor lol
          supports_hdr = -1;
          bitdepth = 10;
          # this monitor doesn't flicker when using VRR at all
          vrr = 1;
          # icc = "${config.age.secrets.m27q.path}";
          cm = "edid";
        };
      };
    };
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

  services.flatpak.enable = true;
}
