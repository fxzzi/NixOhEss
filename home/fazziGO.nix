{pkgs, ...}: {
  home.stateVersion = "25.05";
  cfg = {
    scripts.enable = true;
    xdgConfig.enable = true;
    apps = {
      syncthing.enable = true;
      mpv.enable = true;
      obs-studio.enable = false;
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
        icon = "azzi-laptop";
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
      extraApps.enable = false;
      ncmpcpp.enable = true;
      mpd = {
        enable = true;
      };
    };
    gaming = {
      proton-ge.enable = false;
      celeste = {
        enable = true;
        path = "games/Celeste";
        modding.enable = true;
      };
    };
    gui = {
      walls.directory = "kunzoz";
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
      wleave.enable = true;
      hypr = {
        defaultMonitor = "eDP-1";
        secondaryMonitor = null;
        animations.enable = false;
        hyprland = {
          enable = true;
          # autoStart = true;
        };
        hyprlock.enable = true;
        hypridle = {
          enable = true;
          dpmsTimeout = 300;
          lockTimeout = 330;
          suspendTimeout = 360;
        };
        hyprpaper.enable = true;
        xdph.enable = true;
      };
      dunst.enable = true;
    };
  };
  home.packages = with pkgs; [
    godot3
    telegram-desktop
  ];

  imports = [
    ./modules
  ];
}
