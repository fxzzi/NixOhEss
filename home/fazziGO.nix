{pkgs, ...}: {
  scripts.enable = true;
  xdgConfig.enable = true;
  apps = {
    syncthing.enable = true;
    mpv.enable = true;
    obs-studio.enable = false;
    thunar.enable = true;
    browsers = {
      librewolf.enable = true;
      chromium = {
        enable = false;
      };
    };
  };
  cli = {
    bottom.enable = true;
    fastfetch.enable = true;
    ssh.enable = true;
    zsh.enable = true;
    android.enable = true;
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
    foot.enable = true;
    fuzzel.enable = true;
    wleave.enable = true;
    hypr = {
      defaultMonitor = "eDP-1";
      secondaryMonitor = null;
      hyprland.enable = true;
      hyprlock.enable = true;
      hypridle = {
        enable = true;
        suspendTimeout = 360;
      };
      hyprpaper.enable = true;
      xdph.enable = true;
    };
  };
  home.packages = with pkgs; [
    xournalpp
    godot3
  ];

  imports = [
    ./modules
  ];
}
