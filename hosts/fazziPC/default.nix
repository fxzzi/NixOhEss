{
  pkgs,
  self,
  inputs,
  lib,
  ...
}: {
  system.stateVersion = "25.05";
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
      inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.stremio-linux-shell-rewrite-git
    ];
    xdg.config.files."hypr/hyprland.lua".text =
      lib.mkAfter
      #lua
      ''
        -- hl.config({
        -- 	render = {
        -- 		use_fp16 = 1,
        -- 	},
        -- })

        -- main monitor
        hl.monitor({
        	output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. MO27Q28G 25392F000917",
        	mode = "highres",
        	bitdepth = 10,
        	cm = "srgb", -- use srgb calibrated mode on monitor instead
        	sdr_max_luminance = 203,
        })

        -- secondary monitor
        hl.monitor({
        	output = "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27Q 20120B000001",
        	mode = "highres",
        	supports_hdr = -1, -- hdr sucks on this monitor lol
        	supports_wide_color = -1, -- only supports at lower 120Hz
        	cm = "edid",
        	position = "auto-center-left",
        	vrr = 1, -- this monitor doesn't flicker when using VRR at all
        })
      '';
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
