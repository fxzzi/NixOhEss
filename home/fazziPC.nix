{pkgs, ...}: {
  home.stateVersion = "25.05";
  cfg = {
    scripts.enable = true;
    xdgConfig.enable = true;
    apps = {
      syncthing.enable = true;
      mpv.enable = true;
      obs-studio.enable = true;
      thunar = {
        enable = true;
        collegeBookmarks.enable = true;
      };
      discord.enable = true;
      browsers = {
        librewolf = {
          enable = true;
        };
        chromium = {
          enable = true;
          wootility.enable = true;
          scyrox-s-center.enable = true;
        };
        startpage = {
          enable = true;
          user = "fazzi";
        };
      };
    };
    cli = {
      bottom.enable = true;
      fastfetch = {
        enable = true;
        zshIntegration = true;
        icon = "azzi";
      };
      ssh.enable = true;
      git = {
        enable = true;
        name = "Fazzi";
        email = "faaris.ansari@proton.me";
      };
      zsh.enable = true;
      android.enable = true;
      nh.enable = true;
      nvtop.enable = true;
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
      proton-ge.enable = true;
      prismlauncher.enable = true;
      lutris.enable = true;
      celeste = {
        enable = false; # i launch through lutris anyway
        path = "games/Lutris/celeste";
        modding.enable = true;
      };
      mangohud = {
        enable = true;
        enableSessionWide = false;
      };
      gamescope.enable = true;
      cemu.enable = false;
      heroic.enable = true;
      sgdboop.enable = true;
      osu-lazer.enable = false;
      creamlinux.enable = true;
    };
    gui = {
      smoothScroll.enable = false;
      fontConfig = {
        enable = true;
        apple-fonts.enable = false;
      };
      toolkitConfig = {
        enable = true;
        cursorTheme = "XCursor-Pro-Light";
      };
      wallust.enable = true;
      ags.enable = true;
      foot = {
        enable = true;
        zshIntegration = true;
      };
      fuzzel.enable = true;
      walker.enable = true;
      wleave.enable = true;
      hypr = {
        defaultMonitor = "DP-3";
        secondaryMonitor = "DP-2";
        animations.enable = false;
        hyprland = {
          enable = true;
          autoStart = false;
        };
        hyprlock.enable = true;
        hypridle = {
          enable = true;
          dpmsTimeout = 360;
          lockTimeout = 380;
          suspendTimeout = 600;
        };
        hyprpaper.enable = true;
        xdph.enable = true;
      };
      dunst.enable = true;
    };
  };
  home.packages = with pkgs; [
    qbittorrent-enhanced
    telegram-desktop
    godot3
    losslesscut-bin
    qpwgraph
  ];
  imports = [
    ./modules
  ];
}
