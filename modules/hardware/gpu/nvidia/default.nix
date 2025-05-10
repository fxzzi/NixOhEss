{
  config,
  pkgs,
  lib,
  npins,
  ...
}: {
  imports = [./nvuv];
  options.cfg = {
    gpu = {
      nvidia = {
        exposeTemp = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Exposes nvidia GPU temperature at /tmp/nvidia-temp";
        };
        enable = lib.mkEnableOption "";
      };
    };
  };

  config = lib.mkIf config.cfg.gpu.nvidia.enable {
    nixpkgs.config.cudaSupport = true; # enable cuda support in packages which need it
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      nvidia = {
        open = false;
        gsp.enable = config.hardware.nvidia.open; # if using closed drivers, lets assume you don't want gsp
        powerManagement.enable = true; # Fixes nvidia-vaapi-driver after suspend
        nvidiaSettings = false; # useless on wayland still
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        # FIXME: we are overriding the package below
        videoAcceleration = false;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          (nvidia-vaapi-driver.overrideAttrs {
            version = "0-unstable-${npins.nvidia-vaapi-driver.revision}";
            src = npins.nvidia-vaapi-driver;
          })
        ];
      };
    };
    environment = {
      sessionVariables = {
        # fix hw acceleration and native wayland on losslesscut
        "__EGL_VENDOR_LIBRARY_FILENAMES" = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
        "CUDA_CACHE_PATH" = "${config.hj.xdg.cacheDirectory}/nv";
      };
      # fix high vram usage on discord and hyprland. match with the wrapper procnames
      etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".source =
        ./50-limit-free-buffer-pool.json;
    };
    boot = {
      kernelParams = lib.mkMerge [
        [
          "nvidia.NVreg_UsePageAttributeTable=1" # why this isn't default is beyond me.
          "nvidia.NVreg_EnableResizableBar=1" # enable reBAR
          "nvidia.NVreg_RegistryDwords=RMIntrLockingMode=1" # enable low-latency mode
          # "nvidia_modeset.disable_vrr_memclk_switch=1" # stop really high memclk when vrr is in use.
        ]
        (lib.mkIf config.hardware.nvidia.powerManagement.enable [
          "nvidia.NVreg_TemporaryFilePath=/var/tmp" # store on disk, not /tmp which is on RAM
        ])
      ];
      blacklistedKernelModules = ["nouveau"];
    };
    systemd = {
      services.nvidia-temp = lib.mkIf config.cfg.gpu.nvidia.exposeTemp {
        description = "NVidia GPU temperature monitoring"; # exposes gpu temperature at /tmp/nvidia-temp for monitoring
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
