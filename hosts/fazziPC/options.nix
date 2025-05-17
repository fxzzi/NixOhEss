{
  kernel = {
    type = "zen";
    zenergy.enable = true;
    xone.enable = true;
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
    scheduler = "scx_bpfland";
  };
  networking = {
    enable = true;
    mediamtx.enable = true;
  };
  opentabletdriver.enable = true;
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
    steam.enable = true;
    gamemode.enable = true;
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
  gpu = {
    amdgpu.enable = false;
    nvidia = {
      enable = true;
      exposeTemp = true;
      nvuv = {
        enable = true;
        maxClock = 1830;
        coreOffset = 205;
        memOffset = 1000;
        powerLimit = 150;
      };
    };
  };
  batmon.enable = false;
  secureboot.enable = false;
  tty1-skipusername = true;
  # home-manager.enable = true;
  adb.enable = true;
  scripts.enable = true;
  xdgConfig.enable = true;
  apps = {
    # syncthing.enable = true;
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
    fastfetch = {
      enable = true;
      shellIntegration = true;
      icon = "azzi";
    };
    ssh.enable = true;
    git = {
      enable = true;
      name = "Fazzi";
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
      # useGit = true;
      defaultMonitor = "DP-3";
      secondaryMonitor = "DP-2";
      animations.enable = true;
      hyprland = {
        enable = true;
        autoStart = true;
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
}
