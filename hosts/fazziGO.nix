{ ... }:
{
  kernel = {
    type = "latest";
    higherMaxMapCount = false;
    zenpower.enable = false;
    xone.enable = false;
  };
  audio = {
    pipewire.enable = true;
    rnnoise.enable = false;
  };
  scx = {
    enable = false;
  };
  cachix.enable = true;
  fontConfig.subpixelLayout = "rgb";
  netConfig = {
    enable = true;
    desktopFixedIP.enable = false;
    mediamtx.enable = false;
    networkmanager.enable = true;
  };
  opentabletdriver.enable = false;
  fancontrol.enable = false;
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
  gaming = {
    steam.enable = false;
    gamemode.enable = false;
  };
  gpu = {
    amdgpu.enable = true;
    nvidia = {
      enable = false;
    };
  };
  batmon.enable = true;
  secureboot.enable = true;

}
