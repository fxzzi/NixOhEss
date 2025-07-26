{
  kernel = {
    type = "zen";
    zenergy.enable = true;
    xone.enable = false;
    v4l2.enable = true;
  };
  bootConfig = {
    enable = true;
    keyLayout = "us";
    timeout = 0;
    # greetd.enable = true;
  };
  audio = {
    pipewire = {
      enable = true;
      rnnoise = {
        enable = true;
        vadThreshold = 92;
        vadGracePeriod = 20;
        retroactiveVadGrace = 0;
      };
    };
  };
  scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
  networking = {
    enable = true;
    mediamtx.enable = true;
  };
  opentabletdriver.enable = false;
  hardware = {
    wootingRules.enable = true;
    scyroxRules.enable = true;
  };
  printing.enable = true;
  scanning.enable = false;
  wayland = {
    uwsm.enable = true;
  };
  gaming = {
    steam = {
      enable = true;
      shaderThreads = 6;
    };
    gamemode.enable = false;
    proton-ge.enable = true;
    winewayland.enable = true;
    prismlauncher.enable = true;
    lutris.enable = true;
    celeste = {
      enable = false; # i launch through steam anyway
      path = "games/Lutris/celeste";
      modding.enable = true;
    };
    mangohud = {
      enable = true;
      enableSessionWide = true;
      refreshRate = 175;
    };
    # gamescope.enable = true;
    cemu.enable = true;
    heroic.enable = true;
    sgdboop.enable = true;
    osu-lazer.enable = false;
    creamlinux.enable = false;
    vkbasalt.enable = false;
    # yuzu.enable = true;
  };
  gpu = {
    nvidia = {
      enable = true;
      exposeTemp = true;
      nvuv = {
        enable = true;
        maxClock = 1830;
        coreOffset = 205;
        memOffset = 1000;
        powerLimit = 160;
      };
    };
  };
  tty1-skipusername = true;
  adb.enable = true;
  scripts.enable = true;
  xdgConfig.enable = true;
  apps = {
    # syncthing.enable = true;
    mpv.enable = true;
    obs-studio.enable = true;
    thunar = {
      enable = true;
      collegeBookmarks.enable = false;
    };
    discord = {
      enable = true;
      vencord.enable = true;
    };
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
    fastfetch = {
      enable = true;
      shellIntegration = true;
      icon = "azzi";
    };
    ssh.enable = true;
    git = {
      enable = true;
      name = "fazzi";
      email = "faaris.ansari@proton.me";
    };
    zsh.enable = true;

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
  gui = {
    smoothScroll.enable = false;
    fontconfig = {
      enable = true;
      subpixelLayout = "none";
      useMonoEverywhere = false;
    };
    wallust.enable = true;
    ags.enable = true;
    foot = {
      enable = true;
    };
    fuzzel.enable = true;
    wleave.enable = true;
    hypr = {
      defaultMonitor = "DP-2";
      secondaryMonitor = "DP-3";
      animations.enable = true;
      hyprland = {
        enable = true;
        autoStart = true;
        useGit = true;
      };
      hyprlock.enable = true;
      hypridle = {
        enable = true;
        dpmsTimeout = 390;
        lockTimeout = 480;
        suspendTimeout = 900;
      };
      hyprpaper.enable = true;
      hyprsunset.enable = true;
      xdph.enable = true;
    };
    dunst.enable = true;
  };
}
