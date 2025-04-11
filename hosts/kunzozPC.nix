{
  system.stateVersion = "25.05";
  # brother has 64gb of ram for reasons beyond my understanding
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "42G";
    MemoryMax = "54G";
  };
  cfg = {
    kernel = {
      type = "xanmod_latest";
      higherMaxMapCount = true;
      xone.enable = false;
      v4l2.enable = false;
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
    cachix.enable = true;
    fontConfig = {
      enable = true;
      subpixelLayout = "rgb";
    };
    netConfig = {
      enable = true;
      networkmanager.enable = true;
    };
    opentabletdriver.enable = false;
    hardware = {
      viaRules.enable = true; # keyboard configuration
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
        useGit = false;
      };
      uwsm.enable = true;
      thunar.enable = true;
    };
    gaming = {
      steam.enable = true;
      gamemode.enable = true;
    };
    gpu = {
      amdgpu.enable = true;
    };
    tty1-skipusername = false; # since we are using greetd
    home-manager.enable = true;
    adb.enable = false;
  };
}
