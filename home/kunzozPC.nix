{pkgs, ...}: {
  home.stateVersion = "25.05";
  cfg = {
    scripts.enable = true;
    xdgConfig.enable = true;
    apps = {
      mpv.enable = true;
      obs-studio.enable = true;
      thunar.enable = true;
      discord.enable = true;
      browsers = {
        librewolf = {
          enable = true;
          startpage.enable = false;
        };
        chromium = {
          enable = true;
          via.enable = true;
        };
      };
    };
    cli = {
      bottom.enable = true;
      fastfetch = {
        enable = true;
        zshIntegration = true;
        icon = "kunzoz";
      };
      ssh.enable = true;
      git = {
        enable = true;
        name = "Kunooz";
        email = "syedkunooz@gmail.com";
      };
      zsh.enable = true;
      android.enable = false;
      nh.enable = true;
      nvtop.enable = true;
    };
    gaming = {
      proton-ge.enable = true;
      prismlauncher.enable = true;
      lutris.enable = true;
      celeste = {
        enable = false;
        path = "games/Lutris/celeste";
        modding.enable = false;
      };
      mangohud = {
        enable = true;
        enableSessionWide = false;
      };
      gamescope.enable = false;
      cemu.enable = false;
      heroic.enable = true;
      sgdboop.enable = false;
      osu-lazer.enable = false;
    };
    gui = {
      fontConfig = {
        enable = true;
        apple-fonts.enable = true;
      };
      toolkitConfig = {
        enable = true;
        cursorTheme = "Posy_Cursor";
      };
      wallust.enable = true;
      ags.enable = true;
      foot = {
        enable = true;
        zshIntegration = true;
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
  };
  home.packages = with pkgs; [
    # if you want to add some packages, add them here
    losslesscut-bin
    qbittorrent-enhanced
  ];
  imports = [
    ./modules
  ];
}
