{ ... }:
{
  scripts.enable = true;
  xdgConfig.enable = true;
  apps = {
    mpv.enable = true;
    obs-studio.enable = false;
    thunar.enable = true;
    browsers = {
      librewolf.enable = true;
      chromium = {
        enable = false;
        wootility.enable = false;
      };
    };
  };
  cli = {
    bottom.enable = true;
    fastfetch.enable = true;
    neovim.enable = true;
    ssh.enable = true;
    zsh.enable = true;
  };
  music = {
    extraApps.enable = false;
    mpd.enable = true;
    ncmpcpp.enable = true;
  };
  gaming = {
    enable = false;
    mangohud.enable = false;
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
      hypridle.enable = true;
      hyprpaper.enable = true;
      xdph.enable = true;
    };
  };

  imports = [
    ./modules/default.nix
  ];
}
