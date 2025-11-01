{
  self,
  config,
  lib,
  pkgs,
  pins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge getExe';
  cfg = config.cfg.hardware.nvidia;
in {
  options.cfg.hardware.nvidia = {
    exposeTemp = mkEnableOption "nvidia-temp";
    enable = mkEnableOption "nvidia";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.cudaSupport = true; # enable cuda support in packages which need it
    nixpkgs.overlays = [
      (_: _: {
        egl-wayland = self.packages.${pkgs.stdenv.hostPlatform.system}.egl-wayland2;
      })
    ];
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      nvidia = {
        open = true;
        gsp.enable = config.hardware.nvidia.open; # if using closed drivers, lets assume you don't want gsp
        powerManagement.enable = true; # Fixes nvidia-vaapi-driver after suspend
        nvidiaSettings = false; # useless on wayland still
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        # NOTE: if a new nvidia driver isn't in nixpkgs yet, use below
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "580.95.05";
        #   sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
        #   openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
        #   usePersistenced = false;
        #   useSettings = false;
        # };

        # because we are overriding nvidia-vaapi-driver below we must disable it here
        videoAcceleration = false;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [
          (pkgs.nvidia-vaapi-driver.overrideAttrs {
            version = "0-unstable-${builtins.substring 0 8 pins.nvidia-vaapi-driver.revision}";
            src = pins.nvidia-vaapi-driver;
          })
        ];
      };
    };
    environment = {
      sessionVariables = {
        # disable vsync
        __GL_SYNC_TO_VBLANK = "0";
        # enable gsync / vrr support
        __GL_VRR_ALLOWED = "1";

        # lowest frame buffering -> lower latency
        __GL_MaxFramesAllowed = "1";
        # fix hw acceleration and native wayland on losslesscut
        __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      };
      # fix high vram usage on discord and hyprland. match with the wrapper procnames
      etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".text = builtins.toJSON {
        rules =
          map (proc: {
            pattern = {
              feature = "procname";
              matches = proc;
            };
            profile = "No VidMem Reuse";
          }) [
            "Hyprland"
            ".Hyprland-wrapped"
            "Discord"
            ".Discord-wrapped"
            "DiscordCanary"
            ".DiscordCanary-wrapped"
            "electron"
            ".electron-wrapped"
            "librewolf"
            ".librewolf-wrapped"
            "losslesscut"
          ];
      };
    };
    boot = {
      # early load / early kms
      initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      kernelParams = mkMerge [
        [
          "nvidia.NVreg_UsePageAttributeTable=1" # why this isn't default is beyond me.
          "nvidia.NVreg_EnableResizableBar=1" # enable reBAR
          "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1" # low-latency stuff
        ]
        (mkIf config.hardware.nvidia.powerManagement.enable [
          "nvidia.NVreg_TemporaryFilePath=/var/tmp" # store on disk, not /tmp which is on RAM
        ])
      ];
      blacklistedKernelModules = ["nouveau"];
    };
    systemd.services.nvidia-temp = let
      getTemp = "${getExe' config.hardware.nvidia.package "nvidia-smi"} --query-gpu=temperature.gpu --format=csv,noheader,nounits";
      writeTemp = pkgs.writers.writeDash "writeNvidiaTemp" ''
        while :; do
          printf '%d\n' $(($(${getTemp}) * 1000)) > /tmp/nvidia-temp
          sleep 5
        done
      '';
    in
      mkIf cfg.exposeTemp {
        description = "Nvidia GPU temperature monitoring";
        wantedBy = ["multi-user.target"];
        before = ["fancontrol.service"];
        serviceConfig = {
          Type = "simple";
          ExecStart = writeTemp;
        };
      };
  };
}
