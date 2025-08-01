{
  kernel = {
    type = "zen";
    zenergy.enable = true;
  };
  bootConfig = {
    enable = true;
    keyLayout = "us";
    timeout = 30;
    greetd.enable = true;
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
    networkmanager.enable = true;
  };
  hardware = {
    viaRules.enable = true;
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
    proton-ge.enable = true;
    prismlauncher.enable = true;
    # lutris.enable = true;
    mangohud = {
      enable = true;
      enableSessionWide = true;
      refreshRate = 170;
    };
    heroic.enable = true;
    sgdboop.enable = true;
    creamlinux.enable = true;
  };
  gpu = {
    amdgpu.enable = true;
  };
  # adb.enable = true;
  scripts.enable = true;
  xdgConfig.enable = true;
  apps = {
    mpv.enable = true;
    obs-studio.enable = true;
    thunar = {
      enable = true;
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
        via.enable = true;
      };
      startpage = {
        enable = true;
        user = "kunzooz";
      };
    };
  };
  cli = {
    fastfetch = {
      enable = true;
      shellIntegration = true;
      icon = "kunzoz";
    };
    ssh.enable = true;
    git = {
      enable = true;
      name = "Kunooz";
      email = "syedkunooz@gmail.com";
    };
    zsh.enable = true;

    nh.enable = true;
    nvtop.enable = true;
  };
  gui = {
    smoothScroll.enable = true;
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
    wleave.enable = true;
    hypr = {
      defaultMonitor = "DP-3";
      secondaryMonitor = null;
      animations.enable = true;
      hyprland = {
        enable = true;
        autoStart = false;
        # useGit = true;
      };
      hyprlock.enable = true;
      hypridle = {
        enable = true;
        dpmsTimeout = 600;
        lockTimeout = 620;
        suspendTimeout = 1200;
      };
      hyprpaper.enable = true;
      xdph.enable = true;
    };
    dunst.enable = true;
  };
}
