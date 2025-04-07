{
  system.stateVersion = "25.05";
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "42G";
    MemoryMax = "54G";
  };
  cfg = {
    kernel = {
      type = "xanmod_latest";
      higherMaxMapCount = true;
      zenpower.enable = true;
      xone.enable = false;
      v4l2.enable = false;
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
      scheduler = "scx_bpfland";
    };
    cachix.enable = true;
    fontConfig = {
      enable = true;
      subpixelLayout = "bgr";
    };
    netConfig = {
      enable = true;
      networkmanager.enable = true;
    };
    opentabletdriver.enable = false;
    printing.enable = false;
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
    tty1-skipusername = true;
    home-manager.enable = true;
    adb.enable = false;
  };
}
