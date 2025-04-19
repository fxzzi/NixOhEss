{
  config,
  pkgs,
  lib,
  user,
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
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enables the nvidia GPU configuration";
        };
      };
    };
  };

  config = lib.mkIf config.cfg.gpu.nvidia.enable {
    nixpkgs.config.cudaSupport = true; # enable cuda support in packages which need it
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      nvidia = {
        open = true;
        gsp.enable = config.hardware.nvidia.open; # if using closed drivers, lets assume you don't want gsp
        powerManagement.enable = true; # Fixes nvidia-vaapi-driver after suspend
        nvidiaSettings = false; # useless on wayland still
        # package = config.boot.kernelPackages.nvidiaPackages.beta;
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "575.51.02";
          sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
          openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
          useSettings = false;
          usePersistenced = false;
        };
        # FIXME: we are overriding the package below
        videoAcceleration = false;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          (nvidia-vaapi-driver.overrideAttrs
            {
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
        "CUDA_CACHE_PATH" = "/home/${user}/.cache/nv";
      };
      # fix high vram usage on discord and hyprland. match with the wrapper procnames
      etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".source = ./50-limit-free-buffer-pool.json;
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
