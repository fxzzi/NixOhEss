{pkgs, ...}: {
  scripts.enable = true;
  xdgConfig.enable = true;
  apps = {
    syncthing.enable = true;
    mpv.enable = true;
    obs-studio.enable = false;
    thunar.enable = true;
    discord.enable = true;
    browsers = {
      librewolf.enable = true;
      chromium = {
        enable = false;
      };
    };
  };
  cli = {
    bottom.enable = true;
    fastfetch = {
      enable = true;
      zshIntegration = true;
    };
    ssh.enable = true;
    git.enable = true;
    zsh.enable = true;
    android.enable = true;
    nh.enable = true;
  };
  music = {
    extraApps.enable = false;
    ncmpcpp.enable = true;
    mpd = {
      enable = true;
    };
  };
  gui = {
    fontConfig.enable = true;
    toolkitConfig.enable = true;
    wallust.enable = true;
    ags.enable = true;
    foot = {
      enable = true;
      zshIntegration = true;
    };
    fuzzel.enable = true;
    wleave.enable = true;
    hypr = {
      defaultMonitor = "eDP-1";
      secondaryMonitor = null;
      hyprland = {
        enable = true;
        autoStart = true;
      };
      hyprlock.enable = true;
      hypridle = {
        enable = true;
        suspendTimeout = 360;
      };
      hyprpaper.enable = true;
      xdph.enable = true;
    };
    dunst.enable = true;
  };
  home.packages = with pkgs; [
    godot3
  ];

  imports = [
    ./modules
  ];
}
