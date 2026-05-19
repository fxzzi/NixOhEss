{
  pkgs,
  self,
  inputs,
  lib,
  config,
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
    xdg.config.files."hypr/hyprland.lua".text =
      lib.mkAfter
      #lua
      ''
        -- main monitor
        hl.monitor({
        	output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. MO27Q28G 25392F000917",
        	mode = "highres",
        	bitdepth = 10,
        	cm = "srgb", -- use srgb calibrated mode on monitor instead
          -- icc = "${config.age.secrets.mo27q28g.path}",
          sdr_min_luminance = 0.005,
        	sdr_max_luminance = 203,
        })

        -- secondary monitor
        hl.monitor({
        	output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 20120B000001",
        	mode = "highres",
        	supports_hdr = -1, -- hdr sucks on this monitor lol
        	supports_wide_color = -1, -- only supports at lower 120Hz
          icc = "${config.age.secrets.m27q.path}",
        	position = "auto-center-left",
        	vrr = 1, -- this monitor doesn't flicker when using VRR at all
        })
      '';
  };
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
