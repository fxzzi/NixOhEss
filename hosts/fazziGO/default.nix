{
  system.stateVersion = "25.05";
  # its a laptop with 16gb, i don't want to kill it.
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "8G";
    MemoryMax = "10G";
  };
  programs.light.enable = true;
  cfg = {
    kernel = {
      type = "lts";
      higherMaxMapCount = false;
      zenpower.enable = false;
      xone.enable = false;
      v4l2.enable = false;
    };
    bootConfig = {
      enable = true;
      keyLayout = "uk";
      timeout = 0;
      greetd.enable = true;
    };
    audio = {
      pipewire = {
        enable = true;
        rnnoise.enable = false;
      };
    };
    cachix.enable = true;
    fontConfig = {
      enable = true;
      subpixelLayout = "rgb";
    };
    netConfig = {
      enable = true;
      mediamtx.enable = false;
      networkmanager = {
        enable = true;
        powersaving.enable = true;
      };
    };
    opentabletdriver.enable = false;
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
        useGit = false; # don't use unstable git packages for hypr*
      };
      uwsm.enable = true;
      thunar.enable = true;
    };
    gpu = {
      amdgpu.enable = true;
    };
    batmon.enable = true;
    secureboot.enable = true;
    home-manager.enable = true;
    adb.enable = true;
  };
}
