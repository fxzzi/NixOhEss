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
    ./displays.nix
  ];
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
      # blender
      (retroarch.withCores (cores:
        with cores; [
          bsnes
          beetle-psx-hw
          genesis-plus-gx
          melonds
          mupen64plus
        ]))
      self'.packages.transcode
      self'.packages.stremio-linux-shell
      self'.packages.eden
      self'.packages.flac2opus
      self'.packages.flac2vorbis
    ];
  };
  services.factorio = {
    # enable = true;
    loadLatestSave = true;
    requireUserVerification = false;
    port = 25565;
    game-password = "1234";
    nonBlockingSaving = true;
    admins = ["fazzi"];
  };
  nixpkgs.overlays = [
    (final: prev: {
      retroarch-bare = prev.retroarch-bare.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            (final.fetchpatch {
              url = "https://github.com/libretro/RetroArch/commit/2bc0a25e6f5cf2b67b183792886e24c2ec5d448e.patch";
              sha256 = "sha256-gkpBql5w/xUpddv/6sePb5kZ5gy9huStDthmvoz6Qbk=";
            })
          ];
      });
    })
  ];
}
