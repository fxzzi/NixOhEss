{pkgs, ...}: {
  scripts.enable = true;
  xdgConfig.enable = true;
  apps = {
    syncthing.enable = true;
    mpv.enable = true;
    obs-studio.enable = true;
    thunar.enable = true;
    browsers = {
      librewolf.enable = true;
      chromium = {
        enable = true;
        wootility.enable = true;
      };
    };
  };
  cli = {
    bottom.enable = true;
    fastfetch.enable = true;
    ssh.enable = true;
    git.enable = true;
    zsh.enable = true;
    android.enable = true;
    nh.enable = true;
  };
  music = {
    extraApps.enable = true;
    ncmpcpp.enable = true;
    mpd = {
      enable = true;
      discord-rpc.enable = true;
    };
  };
  gaming = {
    enable = true;
    mangohud.enable = true;
  };
  gui = {
    fontConfig.enable = true;
    toolkitConfig.enable = true;
    wallust.enable = true;
    ags.enable = true;
    foot.enable = true;
    fuzzel.enable = true;
    wleave.enable = true;
    hypr = {
      defaultMonitor = "DP-3";
      secondaryMonitor = "DP-2";
      hyprland.enable = true;
      hyprlock.enable = true;
      hypridle = {
        enable = true;
        suspendTimeout = 480;
      };
      hyprpaper.enable = true;
      xdph.enable = true;
    };
  };
  home.packages = with pkgs; [
    qbittorrent-enhanced
    telegram-desktop
  ];
  imports = [
    ./modules
  ];
}
