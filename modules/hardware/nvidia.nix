{
  config,
  lib,
  pkgs,
  inputs',
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionals getExe';
  cfg = config.cfg.hardware.nvidia;
in {
  options.cfg.hardware.nvidia = {
    exposeTemp = mkEnableOption "nvidia-temp";
    enable = mkEnableOption "nvidia";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.cudaSupport = true; # enable cuda support in packages which need it
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
        #   url = "https://developer.nvidia.com/downloads/vulkan-beta-5809416-linux";
        #   version = "580.94.16";
        #   sha256_64bit = "sha256-DqwALfSNPjLsat4Q9Sg44BACNUyqK+kpUxL5CFzLlRc=";
        #   openSha256 = "sha256-WWql/WBQyWNG+skZgvUFbNCClVjty3s3+QR6NnJhSF4=";
        #   usePersistenced = false;
        #   useSettings = false;
        # };
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        # extraPackages = [
        #   inputs'.azzipkgs.packages.egl-wayland2-git
        # ];
        # extraPackages32 = [
        #   inputs'.azzipkgs.packages.egl-wayland2-git
        # ];
      };
    };
    environment = {
      systemPackages = [
        # this is required for HDR on nvidia 590
        pkgs.vulkan-hdr-layer-kwin6
      ];
      sessionVariables = {
        # disable vsync
        __GL_SYNC_TO_VBLANK = "0";
        # enable gsync / vrr support
        __GL_VRR_ALLOWED = "1";
        # lowest frame buffering -> lower latency
        __GL_MaxFramesAllowed = "1";
        # no idea what this does but apparently useful
        # __GL_YIELD = "usleep";
        # fix hw acceleration and native wayland on losslesscut
        __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
        # fix hw acceleration in bwrap (osu!lazer, wrapped appimages)
        __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS = "/run/opengl-driver/share/egl/egl_external_platform.d";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        # stop forcing high GPU clocks when CUDA is in use
        CUDA_DISABLE_PERF_BOOST = 1;
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
            ".Hyprland-wrapped"
            "Discord"
            ".Discord-wrapped"
            "electron"
            ".electron-wrapped"
            "librewolf"
            ".librewolf-wrapped"
            "losslesscut"
            ".losslesscut-wrapped"
            "hyprpaper"
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
      blacklistedKernelModules = ["nouveau"];

      kernelParams =
        [
          "nvidia.NVreg_UsePageAttributeTable=1" # why this isn't default is beyond me.
          "nvidia.NVreg_EnableResizableBar=1" # enable reBAR
          "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1" # low-latency stuff
          "nvidia-modeset.disable_vrr_memclk_switch=1"
        ]
        ++ optionals config.hardware.nvidia.powerManagement.enable [
          "nvidia.NVreg_TemporaryFilePath=/var/tmp" # store on disk, not /tmp which is on RAM
          "nvidia.NVreg_EnableS0ixPowerManagement=0"
        ];
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
