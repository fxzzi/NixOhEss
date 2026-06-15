{
  config,
  lib,
  pkgs,
  inputs,
  npinsSources,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.hardware.nvidia;
in {
  options.cfg.hardware.nvidia.enable = mkEnableOption "nvidia";

  config = mkIf cfg.enable {
    nixpkgs.config.cudaSupport = true; # enable cuda support in packages which need it
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [
          (pkgs.nvidia-vaapi-driver.overrideAttrs {
            src = npinsSources.nvidia-vaapi-driver;
            version = "0-unstable-${builtins.substring 0 8 npinsSources.nvidia-vaapi-driver.revision}";
          })
        ];
      };
      nvidia = {
        open = true;
        gsp.enable = config.hardware.nvidia.open; # if using closed drivers, lets assume you don't want gsp
        powerManagement.enable = true;
        nvidiaSettings = false; # useless on wayland still
        videoAcceleration = false; # override above
        branch = "bleeding_edge"; # newest of latest and beta
        # NOTE: if a new nvidia driver isn't in nixpkgs yet, use below
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "595.71.05";
        #   sha256_64bit = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
        #   openSha256 = "sha256-Lfz71QWKM6x/jD2B22SWpUi7/og30HRlXg1kL3EWzEw=";
        #   usePersistenced = false;
        #   useSettings = false;
        # };
        moduleParams = {
          nvidia = {
            NVreg_UsePageAttributeTable = 1; # why this isn't default is beyond me.
            NVreg_EnableResizableBar = 1; # enable reBAR
            "NVreg_RegistryDwords=RmEnableAggressiveVblank" = 1; # low-latency stuff
          };
          nvidia-modeset.disable_vrr_memclk_switch = 1; # don't force P0 when VRR is active
        };
      };
    };
    environment = {
      systemPackages = [
        inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.dxvk-nvapi-vkreflex-layer
      ];
      sessionVariables = {
        # disable vsync
        __GL_SYNC_TO_VBLANK = "0";
        # enable gsync / vrr support
        __GL_VRR_ALLOWED = "1";
        # lowest frame buffering -> lower latency
        __GL_MaxFramesAllowed = "1";

        # enable saving shaders to disk
        __GL_SHADER_DISK_CACHE = 1;
        # increase max size to xGB
        __GL_SHADER_DISK_CACHE_SIZE = 12 * 1024 * 1024 * 1024;
        # clean up ~
        __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";

        # fix hw acceleration in bwrap (osu!lazer, wrapped appimages, losslesscut)
        __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS = "/run/current-system/etc/egl/egl_external_platform.d";

        # avoid creation of $HOME/.nv dir
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        # stop forcing high GPU clocks when CUDA is in use
        CUDA_DISABLE_PERF_BOOST = 1;

        # Report support for D3D12 NVIDIA shader extensions when being supported by VKD3D-Proton.
        # https://github.com/jp7677/dxvk-nvapi/releases/tag/v0.9.2
        DXVK_NVAPI_D3D12_NV_SHADER_EXTN = 1;
        # also enable descriptor heap
        VKD3D_CONFIG = "descriptor_heap";
        # only really helps on dx12 for now
        # DXVK_CONFIG = "dxvk.enableDescriptorHeap = True;";
      };
      etc = {
        "nvidia/nvidia-application-profiles-rc.d/50-vram-alloc-fixes.json".text = builtins.toJSON {
          rules = [
            {
              pattern = {
                feature = "true";
                matches = "";
              };
              # fix high vram usage on some apps. nvidia tries to do this automatically but only for select programs
              profile = "No VidMem Reuse";
            }
          ];
        };
        "nvidia/nvidia-application-profiles-rc.d/51-dont-nerf-cuda-perf.json".text = builtins.toJSON {
          rules = [
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
    # early load / early kms
    boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };
}
