{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  options.gpu.nvidia.exposeTemp = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Exposes nvidia GPU temperature at /tmp/nvidia-temp";
  };
  options.gpu.nvidia.nvuv.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the nvuv undervolt service.";
  };
  options.gpu.nvidia.nvuv.maxClock = lib.mkOption {
    type = lib.types.unsignedInt;
    default = 0;
    description = "Changes the max clock passed into nvuv.";
  };
  options.gpu.nvidia.nvuv.coreOffset = lib.mkOption {
    type = lib.types.unsignedInt;
    default = 0;
    description = "Changes the core offset passed into nvuv.";
  };
  options.gpu.nvidia.nvuv.memOffset = lib.mkOption {
    type = lib.types.unsignedInt;
    default = 0;
    description = "Changes the memory offset passed into nvuv.";
  };
  options.gpu.nvidia.nvuv.powerLimit = lib.mkOption {
    type = lib.types.unsignedInt;
    default = 0;
    description = "Changes the power limit passed into nvuv";
  };
  options.gpu.nvidia.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the nvidia GPU configuration";
  };

  config = lib.mkIf config.gpu.nvidia.enable {
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
      services.nvidia-gpu-temperature = lib.mkIf config.gpu.nvidia.exposeTemp {
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
      services.nvidia-undervolt = lib.mkIf config.gpu.nvidia.nvuv.enable {
        description = "NVidia Undervolting script";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${
            lib.getExe inputs.nvuv.packages.${pkgs.system}.nvuv
          } \
						${config.gpu.nvidia.nvuv.maxClock} \
						${config.gpu.nvidia.nvuv.coreOffset} \
						${config.gpu.nvidia.nvuv.memOffset} \
						${config.gpu.nvidia.nvuv.powerLimit}";
        };
      };
    };
  };
}
