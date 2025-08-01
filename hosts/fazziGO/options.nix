{
  cfg = {
    kernel = {
      type = "latest";
    };
    scx = {
      enable = true;
      scheduler = "scx_lavd";
      flags = ["--autopower"];
    };
    bootConfig = {
      enable = true;
      keyLayout = "uk";
      timeout = 0;
      greetd.enable = true;
    };
    audio = {
      pipewire = {
        enable = true;
      };
    };

    networking = {
      enable = true;
      networkmanager = {
        enable = true;
        powersaving.enable = true;
      };
    };
    printing.enable = true;
    scanning.enable = false;
    wayland = {
      uwsm.enable = true;
    };
    gaming = {
      prismlauncher.enable = true;
      steam.enable = true;
      celeste = {
        enable = false;
        modding.enable = true;
      };
    };
    gpu = {
      amdgpu.enable = true;
    };
    secureboot.enable = true;
    watt.enable = true;
    adb.enable = true;
    scripts.enable = true;
    xdgConfig.enable = true;
    apps = {
      syncthing.enable = true;
      mpv.enable = true;
      thunar = {
        enable = true;
        collegeBookmarks.enable = true;
      };
      discord = {
        enable = true;
        minimizeToTray = false;
        vencord.enable = true;
      };
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
      fastfetch = {
        enable = true;
        shellIntegration = true;
        icon = "azzi-laptop";
      };
      ssh.enable = true;
      git = {
        enable = true;
        name = "Fazzi";
        email = "faaris.ansari@proton.me";
      };
      zsh.enable = true;

      nh.enable = true;
    };
    music = {
      ncmpcpp.enable = true;
      mpd = {
        enable = true;
        discord-rpc.enable = false;
      };
    };
    gui = {
      smoothScroll.enable = false;
      fontconfig = {
        enable = true;
        subpixelLayout = "rgb";
      };
      wallust.enable = true;
      ags.enable = true;
      foot = {
        enable = true;
      };
      fuzzel.enable = true;
      # walker.enable = true;
      wleave.enable = true;
      hypr = {
        defaultMonitor = "eDP-1";
        secondaryMonitor = null;
        animations.enable = true;
        blur.enable = false;
        hyprland = {
          enable = true;
          # useGit = true;
        };
        hyprlock.enable = true;
        hypridle = {
          enable = true;
          dpmsTimeout = 300;
          lockTimeout = 360;
          suspendTimeout = 420;
        };
        hyprpaper.enable = true;
        hyprsunset.enable = true;
        xdph.enable = true;
      };
      dunst.enable = true;
    };
  };
}
