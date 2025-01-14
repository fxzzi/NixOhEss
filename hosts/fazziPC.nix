_: {
  kernel = {
    type = "zen";
    higherMaxMapCount = true;
    zenpower.enable = true;
    xone.enable = true;
    v4l2.enable = true;
  };
  bootConfig = {
    enable = true;
    keyLayout = "us";
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
    scheduler = "scx_lavd";
  };
  cachix.enable = true;
  fontConfig = {
    enable = true;
    subpixelLayout = "bgr";
  };
  netConfig = {
    enable = true;
    desktopFixedIP.enable = true;
    mediamtx.enable = true;
    networkmanager.enable = false;
  };
  opentabletdriver.enable = true;
  fancontrol.enable = true;
  services = {
    cups.enable = true;
    wootingRules.enable = true;
  };
  security.enable = true;
  user = {
    enable = true;
    shell = "zsh";
  };
  wayland = {
    hyprland.enable = true;
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
}
