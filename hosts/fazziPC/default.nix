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
      qpwgraph
      steamguard-cli
      picard
      rsgain
      olympus
      nicotine-plus
      sgdboop
      cemu
      nvtopPackages.nvidia
      stremio
      yt-dlp
      customPkgs.transcode
    ];
    xdg.config.files."hypr/hyprland.conf".value = {
      render.new_render_scheduling = true;
    };
  };
}
