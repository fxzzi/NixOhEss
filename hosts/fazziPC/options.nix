{
  core.kernel = {
    type = "zen";
    zenergy.enable = true;
    xone.enable = false;
    v4l2.enable = true;
  };
  services = {
    mediamtx.enable = true;
    mate-polkit.enable = true;
    gcr-ssh-agent.enable = true;
    pipewire = {
      enable = true;
      rnnoise = {
        enable = true;
        vadThreshold = 92;
        vadGracePeriod = 20;
        retroactiveVadGrace = 0;
      };
    };
    scx = {
      enable = true;
      scheduler = "scx_bpfland";
    };
    syncthing.enable = true;
    mpd = {
      enable = true;
      discord-rpc.enable = true;
    };
    hypridle = {
      enable = true;
      dpmsTimeout = 390;
      lockTimeout = 480;
      suspendTimeout = 900;
    };
    hyprpaper.enable = true;
    hyprsunset.enable = true;
    xdph.enable = true;
    dunst.enable = true;
    greetd.enable = true;
  };
  core = {
    boot = {
      enable = true;
      keyLayout = "us";
      timeout = 0;
    };
    networking = {
      enable = true;
    };
    xdg.enable = true;
    fonts.enable = true;
  };
  hardware = {
    wootingRules.enable = true;
    scyroxRules.enable = true;
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
  printing.enable = true;
  scanning.enable = false;
  programs = {
    proton-ge.enable = true;
    mangohud.enable = true;
    nvf.enable = true;
    steam.enable = true;
    prismlauncher.enable = true;
    lutris.enable = true;
    heroic.enable = true;
    uwsm.enable = true;
    adb.enable = true;
    scripts.enable = true;
    mpv.enable = true;
    obs-studio.enable = true;
    thunar = {
      enable = true;
    };
    discord = {
      enable = true;
      vencord.enable = true;
    };
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
    ncmpcpp.enable = true;
    ags = {
      enable = true;
    };
    wleave.enable = true;
    hyprland = {
      enable = true;
      defaultMonitor = "DP-2";
      secondaryMonitor = "DP-3";
      animations.enable = true;
      # autoStart = true;
      useGit = true;
    };
    hyprlock.enable = true;
    wallust.enable = true;
    foot.enable = true;
    fuzzel.enable = true;
  };
}
