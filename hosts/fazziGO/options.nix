{
  cfg = {
    core = {
      username = "faaris";
      kernel.type = "latest";
      boot = {
        enable = true;
        keyLayout = "uk";
        timeout = 0;
        secureboot.enable = true;
      };
      xdg.enable = true;
      fonts.enable = true;

      networking = {
        enable = true;
        networkmanager = {
          enable = true;
          powersaving.enable = true;
        };
      };
    };

    services = {
      mate-polkit.enable = true;
      gcr-ssh-agent.enable = true;
      watt.enable = true;

      scx = {
        enable = true;
        scheduler = "scx_lavd";
        flags = ["--autopower"];
      };
      pipewire = {
        enable = true;
      };
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
      greetd.enable = true;
    };

    services.printing.enable = true;
    hardware.scanning.enable = false;
    hardware = {
      amdgpu.enable = true;
    };

    programs = {
      smoothScroll.enable = false;
      nvf.enable = true;
      uwsm.enable = true;
      adb.enable = true;
      scripts.enable = true;
      wallust.enable = true;
      foot.enable = true;
      fuzzel.enable = true;
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
  };
}
