_: {
  programs.light.enable = true;
  kernel = {
    type = "latest";
    higherMaxMapCount = false;
    zenpower.enable = false;
    xone.enable = false;
    v4l2.enable = false;
  };
  bootConfig = {
    enable = true;
    keyLayout = "uk";
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
    networkmanager.enable = true;
  };
  opentabletdriver.enable = false;
  services = {
    enable = true;
    wootingRules.enable = false;
  };
  user = {
    enable = true;
    shell = "zsh";
  };
  wayland = {
    hyprland.enable = true;
    thunar.enable = true;
  };
  gpu = {
    amdgpu.enable = true;
  };
  batmon.enable = true;
  secureboot.enable = true;
  tty1-skipusername = true;
  home-manager.enable = true;
  adb.enable = true;
}
