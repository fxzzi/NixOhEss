{pkgs, ...}: {
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
      customPkgs.transcode
      customPkgs.stremio-enhanced
      customPkgs.eden
      customPkgs.flac2opus
      customPkgs.flac2vorbis
    ];
  };
  services.factorio = {
    enable = true;
    loadLatestSave = true;
    requireUserVerification = false;
    port = 25565;
    game-password = "1234";
    nonBlockingSaving = true;
    admins = ["fazzi"];
  };
}
