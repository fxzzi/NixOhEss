{
  cfg = {
    core = {
      username = "faaris";
      kernel = {
        type = "xanmod";
        zenergy.enable = true;
        v4l2.enable = true;
      };

      boot = {
        enable = true;
        keyLayout = "us";
        timeout = 0.25;
      };
      networking.enable = true;
      fonts.enable = true;
    };
    hardware = {
      nvidia.enable = true;
      bluetooth.enable = true;
      # scanning.enable = true;
    };
    services = {
      ags.enable = true;
      # kdeconnect.enable = true;
      nvuv = {
        enable = true;
        maxClock = 1830;
        coreOffset = 205;
        memOffset = 850;
        powerLimit = 150;
        tempMonitor = {
          enable = true;
        };
      };
      stash.enable = true;
      mullvad.enable = true;
      mediamtx.enable = true;
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
      syncthing.enable = true;
      mpd = {
        enable = true;
        discord-rpc.enable = true;
        notification.enable = true;
      };
      hypridle = {
        enable = true;
        dpmsTimeout = 300;
        lockTimeout = 480;
        suspendTimeout = 900;
      };
      hyprpaper.enable = true;
      hyprsunset.enable = true;
      xdph.enable = true;
      dunst.enable = true;
      greetd.enable = true;
      printing.enable = true;
    };
    programs = {
      gpu-screen-recorder.enable = true;
      # gamescope.enable = true;
      osu.enable = true;
      smoothScroll.enable = false;
      proton-ge = {
        enable = true;
        ntsync = true;
        # nativeWayland = true;
      };
      mangohud = {
        enable = true;
        enableSessionWide = true;
        refreshRate = 280;
      };

      nvf.enable = true;
      steam = {
        enable = true;
        shaderThreads = 6;
      };
      prismlauncher = {
        enable = true;
        # waywall.enable = true;
      };
      lutris.enable = true;
      heroic.enable = true;
      adb.enable = true;
      mpv.enable = true;
      obs-studio.enable = true;
      thunar.enable = true;
      discord.enable = true;
      librewolf.enable = true;
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
        icon = "azzi-yawn";
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
      wleave.enable = true;
      hyprland = {
        enable = true;
        defaultMonitor = "DP-3";
        secondaryMonitor = "DP-2";
        useGit = true;
      };
      hyprlock.enable = true;
      wallust.enable = true;
      foot.enable = true;
      fuzzel.enable = true;
    };
  };
}
