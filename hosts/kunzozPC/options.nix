{
  cfg = {
    core = {
      username = "kunzoz";
      kernel = {
        type = "xanmod";
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
      lact.enable = true;
      # activate-linux.enable = true;
      ags.enable = true;
      kdeconnect.enable = true;
      stash.enable = true;
      mate-polkit.enable = true;
      gcr-ssh-agent.enable = true;
      pipewire = {
        enable = true;
        rnnoise = {
          enable = true;
          vadThreshold = 97;
          vadGracePeriod = 50;
          retroactiveVadGrace = 0;
        };
      };

      scx = {
        enable = true;
        scheduler = "scx_bpfland";
      };

      hyprsunset.enable = true;
      hypridle = {
        enable = true;
        dpmsTimeout = 600;
        lockTimeout = 620;
        suspendTimeout = 0;
      };
      hyprpaper.enable = true;
      xdph.enable = true;
      dunst.enable = true;
      greetd.enable = true;

      printing.enable = true;
    };
    hardware = {
      amdgpu.enable = true;
      scanning.enable = false;
    };
    programs = {
      codium = {
        enable = true;
        # kunzoz is noob and needs gui editor
        defaultEditor = true;
      };
      gamescope.enable = true;
      gpu-screen-recorder.enable = true;
      adb.enable = true;
      mangohud = {
        enable = true;
        enableSessionWide = true;
        refreshRate = 170;
      };
      heroic.enable = true;
      lutris.enable = true;
      wallust.enable = true;
      fuzzel = {
        enable = true;
        disableCache = false;
      };
      foot.enable = true;
      nvf.enable = true;
      steam = {
        enable = true;
        shaderThreads = 6;
      };
      prismlauncher = {
        enable = true;
        waywall.enable = true;
      };
      proton-ge = {
        enable = true;
        ntsync = true;
      };
      mpv.enable = true;
      obs-studio.enable = true;
      thunar = {
        enable = true;
        view = "Details"; # weirdo...
      };
      discord.enable = true;
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
      wleave.enable = true;
      hyprland = {
        enable = true;
        defaultMonitor = "DP-3";
        secondaryMonitor = null;
        # useGit = true;
        extraConfig = {
          render = {
            # sidestep all cm issues by just disabling it
            cm_enabled = 0;
            # same with ds
            direct_scanout = 0;
          };
          # same with tearing
          general.allow_tearing = 0;
          # idk why this option is so controversial but ok garmin video speichern
          binds.workspace_back_and_forth = false;
        };
      };
      hyprlock.enable = true;
    };
  };
}
