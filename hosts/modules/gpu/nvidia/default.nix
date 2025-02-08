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

    specialisation."nvidia-open".configuration = {
      environment.etc."specialisation".text = "nvidia-closed";
      hardware.nvidia.open = lib.mkForce (! config.hardware.nvidia.open);
    };

    hardware = {
      nvidia = {
        open = false;
        gsp.enable = config.hardware.nvidia.open; # if using closed drivers, lets assume you don't want gsp
        powerManagement.enable = true; # Fixes nvidia-vaapi-driver after suspend
        nvidiaSettings = false;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
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
        [
          "nvidia.NVreg_UsePageAttributeTable=1" # why this isn't default is beyond me.
          "nvidia_modeset.disable_vrr_memclk_switch=1" # stop really high memclk when vrr is in use.
        ]
        (lib.mkIf config.hardware.nvidia.powerManagement.enable [
          "nvidia.NVreg_TemporaryFilePath=/var/tmp" # store on disk, not /tmp which is on RAM
        ])
      ];
      blacklistedKernelModules = ["nouveau"];
      initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    };
    systemd = {
      services.nvidia-temp = lib.mkIf config.gpu.nvidia.exposeTemp {
        description = "NVidia GPU temperature monitoring"; # exposes gpu temperature at /tmp/nvidia-temp for monitoring
        wantedBy = ["multi-user.target"];
        before = ["fancontrol.service"];
        script = ''
          while :; do
          	temp="$(${lib.getExe' config.hardware.nvidia.package "nvidia-smi"} --query-gpu=temperature.gpu --format=csv,noheader,nounits)"
          	echo "$((temp * 1000))" > /tmp/nvidia-temp
          	sleep 5 # loop every x seconds
          done
        '';
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = 5;
        };
      };
    };
    # maybe fix high vram usage on Hyprland?
    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".source = ./50-limit-free-buffer-pool-in-wayland-compositors.json;
  };
}
