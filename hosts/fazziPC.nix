{
  system.stateVersion = "25.05";
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "16G";
    MemoryMax = "24G";
  };
  cfg = {
    kernel = {
      type = "zen";
      higherMaxMapCount = true;
      zenpower.enable = false;
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
    cachix.enable = true;
    fontConfig = {
      enable = true;
      subpixelLayout = "none";
    };
    netConfig = {
      enable = true;
      desktopFixedIP.enable = true;
      mediamtx.enable = true;
      networkmanager.enable = false;
    };
    opentabletdriver.enable = true;
    fancontrol.enable = true;
    hardware = {
      wootingRules.enable = true;
      scyroxRules.enable = true;
    };
    printing.enable = true;
    scanning.enable = false;
    security.enable = true;
    user = {
      enable = true;
      shell = "zsh";
    };
    wayland = {
      hyprland = {
        enable = true;
        useGit = true;
      };
      uwsm.enable = true;
      thunar.enable = true;
    };
    gaming = {
      steam.enable = true;
      gamemode.enable = true;
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
    home-manager.enable = true;
    adb.enable = true;
  };
}
