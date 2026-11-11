{
  pkgs,
  self,
  inputs,
  ...
}:
{
  system.stateVersion = "25.05";
  # host specific packages
  hj = {
    packages = with pkgs; [
      qbittorrent
      losslesscut
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
      claude-code
      # stremio-linux-shell
      (retroarch.withCores (
        cores: with cores; [
          bsnes
          beetle-psx-hw
          pcsx2
          genesis-plus-gx
          melonds
          mupen64plus
        ]
      ))
      self.packages.${pkgs.stdenv.hostPlatform.system}.transcode
      inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.flac2vorbis
      inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.flac2opus
    ];
  };
  hardware.display = {
    edid = {
      enable = true;
      packages = [
        # the M27Q has a broken EDID. It's physical size is reported as 32in when
        # its 27in, and the VRR range is reported as 48-165Hz when the monitor
        # in fact goes up to 170Hz.
        # so I edited the EDID with a few changes:
        # - Physical size changed to 60x34cm
        # - VRR range widened to 32-170Hz
        # - Removed 10-bit, because it was using FRC which is not true 10-bit
        (pkgs.runCommand "M27Q" { } ''
          install -Dm444 ${./M27Q-edid.bin} "$out/lib/firmware/edid/M27Q.bin"
        '')
      ];
    };
    # set resolutions early to avoid modeset when launching hyprland
    outputs = {
      "DP-3".mode = "2560x1440-30@280";
      "DP-2" = {
        edid = "M27Q.bin";
        mode = "2560x1440-24@170";
      };
    };
  };
  environment.sessionVariables = {
    # force HDR in proton-ge. It can't determine HDR support for
    # itself when using cm_auto_hdr.
    PROTON_FORCE_HDR = 1;
    # wtf is it with these clankers not following XDG
    CLAUDE_CONFIG_DIR = "$XDG_CONFIG_HOME/claude";
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

  networking = {
    firewall =
      let
        allowedPorts = [
          6881 # qbittorrent
          2234 # slsk / nicotine+
          25565 # minecraft
        ];
      in
      {
        allowedTCPPorts = allowedPorts;
        allowedUDPPorts = allowedPorts;
      };
  };

}
