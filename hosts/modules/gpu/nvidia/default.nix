{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./nvuv];
  options = {
    gpu = {
      nvidia = {
        exposeTemp = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Exposes nvidia GPU temperature at /tmp/nvidia-temp";
        };
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enables the nvidia GPU configuration";
        };
      };
    };
  };

  config = lib.mkIf config.gpu.nvidia.enable {
    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
      nvidia = {
        open = true; # toggle open kernel modules
        modesetting.enable = true; # toggle modesetting for wayland
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
    environment.sessionVariables = {
      "__EGL_VENDOR_LIBRARY_FILENAMES" = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
    };
    boot = {
      kernelParams = lib.mkMerge [
        ["nvidia.NVreg_UsePageAttributeTable=1"]
        (lib.mkIf config.hardware.nvidia.powerManagement.enable [
          "nvidia.NVreg_TemporaryFilePath=/var/tmp"
        ])
      ];
      blacklistedKernelModules = ["nouveau"];
      initrd = {
        kernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
      };
    };
    systemd = {
      services.nvidia-temp = lib.mkIf config.gpu.nvidia.exposeTemp {
        description = "NVidia GPU temperature monitoring";
        wantedBy = ["multi-user.target"];
        before = ["fancontrol.service"];
        script = ''
          while :; do
          	temp="$(${lib.getExe' config.hardware.nvidia.package "nvidia-smi"} --query-gpu=temperature.gpu --format=csv,noheader,nounits)"
          	echo "$((temp * 1000))" > /tmp/nvidia-temp
          	sleep 5
          done
        '';
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = 5;
        };
      };
    };
  };
}
