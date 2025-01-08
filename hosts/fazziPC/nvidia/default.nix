{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      open = true; # Set to false until wake-up from suspend is fixed
      modesetting.enable = true; # Enable modesetting in nvidia for nvidia-vaapi-driver
      powerManagement.enable = true; # Fixes nvidia-vaapi-driver after suspend
      package = config.boot.kernelPackages.nvidiaPackages.beta; # Use beta drivers
      nvidiaSettings = false; # Disable nvidia-settings applet, useless on Wayland
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
  };
  boot.kernelParams = [ "nvidia.NVreg_UsePageAttributeTable=1" ];
  boot.initrd = {
    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };
  systemd = {
    services.nvidia-gpu-temperature = {
      description = "NVidia GPU temperature monitoring";
      wantedBy = [ "multi-user.target" ];
      before = [ "fancontrol.service" ];
      script = ''
        while :; do
        	t="$(${lib.getExe' config.hardware.nvidia.package "nvidia-smi"} --query-gpu=temperature.gpu --format=csv,noheader,nounits)"
        	echo "$((t * 1000))" > /tmp/nvidia-temp
        	sleep 5
        done
      '';
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
      };
    };
    services.nvidia-undervolt = {
      description = "NVidia Undervolting script";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe inputs.nvuv.packages.${pkgs.system}.nvuv} 1830 205 1000 150";
      };
    };
  };
}
