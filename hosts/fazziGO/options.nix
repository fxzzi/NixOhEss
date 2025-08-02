{
  kernel = {
    type = "latest";
  };
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    flags = ["--autopower"];
  };
  boot = {
    enable = true;
    keyLayout = "uk";
    timeout = 0;
    greetd.enable = true;
  };
  services = {
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
  programs.uwsm.enable = true;
  gaming = {
    prismlauncher.enable = true;
    steam.enable = true;
    celeste = {
      enable = false;
      modding.enable = true;
    };
  };
  hardware = {
    amdgpu.enable = true;
  };
  secureboot.enable = true;
  services.watt.enable = true;
  programs.adb.enable = true;
  scripts.enable = true;
  xdg.enable = true;
  programs = {
    mpv.enable = true;
    thunar = {
      enable = true;
    };
    discord = {
      enable = true;
      minimizeToTray = false;
      vencord.enable = true;
    };
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
    ncmpcpp.enable = true;
    ags = {
      enable = true;
    };
    wleave.enable = true;
    hyprland = {
      enable = true;
      defaultMonitor = "eDP-1";
      secondaryMonitor = null;
      animations.enable = true;
      blur.enable = false;
      # useGit = true;
    };
    hyprlock.enable = true;
  };
  services = {
    syncthing.enable = true;
    mpd = {
      enable = true;
      discord-rpc.enable = false;
    };
    hypridle = {
      enable = true;
      dpmsTimeout = 300;
      lockTimeout = 360;
      suspendTimeout = 420;
    };
    hyprpaper.enable = true;
    hyprsunset.enable = true;
    xdph.enable = true;
    dunst.enable = true;
  };
  programs = {
    wallust.enable = true;
    foot.enable = true;
    fuzzel.enable = true;
    # walker.enable = true;
  };
}
