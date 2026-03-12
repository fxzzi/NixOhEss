{
  config,
  lib,
  pkgs,
  pins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionals getExe';
  cfg = config.cfg.hardware.nvidia;
  isOpen = config.hardware.nvidia.open;
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
        gsp.enable = isOpen; # if using closed drivers, lets assume you don't want gsp
        powerManagement.enable = !isOpen;
        nvidiaSettings = false; # useless on wayland still
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        # NOTE: if a new nvidia driver isn't in nixpkgs yet, use below
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "595.45.04";
        #   sha256_64bit = "sha256-zUllSSRsuio7dSkcbBTuxF+dN12d6jEPE0WgGvVOj14=";
        #   openSha256 = "sha256-uqNfImwTKhK8gncUdP1TPp0D6Gog4MSeIJMZQiJWDoE=";
        #   usePersistenced = false;
        #   useSettings = false;
        # };
      };
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
    environment = {
      systemPackages = [
        (pkgs.callPackage "${pins.nix-gaming}/pkgs/dxvk-nvapi/vkreflex-layer.nix" {
          pins = import "${pins.nix-gaming}/npins";
        })
      ];
      sessionVariables = {
        # disable vsync
        __GL_SYNC_TO_VBLANK = "0";
        # enable gsync / vrr support
        __GL_VRR_ALLOWED = "1";
        # lowest frame buffering -> lower latency
        __GL_MaxFramesAllowed = "1";
        # fix hw acceleration and native wayland on losslesscut
        __EGL_VENDOR_LIBRARY_CONFIG_DIRS = "/run/opengl-driver/share/glvnd/egl_vendor.d/";
        # fix hw acceleration in bwrap (osu!lazer, wrapped appimages)
        __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS = "/run/opengl-driver/share/egl/egl_external_platform.d/";
        # avoid creation of $HOME/.nv dir
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        # stop forcing high GPU clocks when CUDA is in use
        CUDA_DISABLE_PERF_BOOST = 1;
      };
      etc = {
        "nvidia/nvidia-application-profiles-rc.d/50-vram-and-cuda-fixes.json".text = builtins.toJSON {
          rules = [
            {
              pattern = {
                feature = "true";
                matches = "";
              };
              # fix high vram usage on some apps. nvidia tries to do this automatically but only for select programs
              profile = "No VidMem Reuse";
            }
            {
              pattern = {
                feature = "true";
                matches = "";
              };
              # don't lock to a lower (p2) perf state when cuda is in use.
              profile = "CudaNoStablePerfLimit";
            }
          ];
        };
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
          "nvidia.NVreg_TemporaryFilePath=/var/tmp" # store on disk, not /tmp which is on RAM
        ]
        ++ optionals isOpen [
          "nvidia.NVreg_UseKernelSuspendNotifiers=1"
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
