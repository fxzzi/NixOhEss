{
  cfg = {
    core = {
      username = "kunzoz";
      kernel = {
        type = "zen";
        zenergy.enable = true;
      };
      boot = {
        enable = true;
        keyLayout = "us";
        timeout = 30;
      };
      networking = {
        enable = true;
        networkmanager.enable = true;
      };
      fonts.enable = true;
    };
    services = {
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

      hypridle = {
        enable = true;
        dpmsTimeout = 600;
        lockTimeout = 620;
        suspendTimeout = 1200;
      };
      hyprpaper.enable = true;
      xdph.enable = true;
      dunst.enable = true;
      greetd.enable = true;

      printing.enable = true;
    };
    hardware = {
      rules.via.enable = true;
      amdgpu.enable = true;
      scanning.enable = false;
    };
    programs = {
      mangohud = {
        enable = true;
        enableSessionWide = true;
        refreshRate = 170;
      };
      heroic.enable = true;
      lutris.enable = true;
      wallust.enable = true;
      fuzzel.enable = true;
      scripts.enable = true;
      foot.enable = true;
      uwsm.enable = true;
      nvf.enable = true;
      steam = {
        enable = true;
        shaderThreads = 6;
      };
      prismlauncher.enable = true;
      proton-ge = {
        enable = true;
        ntsync = true;
      };
      mpv.enable = true;
      obs-studio.enable = true;
      thunar.enable = true;
      discord = {
        enable = true;
        vencord.enable = true;
      };
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
      ags = {
        enable = true;
      };
      wleave.enable = true;
      hyprland = {
        enable = true;
        defaultMonitor = "DP-3";
        secondaryMonitor = null;
        # useGit = true;
      };
      hyprlock.enable = true;
    };
  };
}
