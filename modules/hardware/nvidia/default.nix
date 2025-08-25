{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge getExe';
  cfg = config.cfg.hardware.nvidia;
  patchedPkg = config.boot.kernelPackages.nvidiaPackages.beta.overrideAttrs (old: {
    postFixup = ''
      substituteInPlace $out/share/vulkan/icd.d/nvidia_icd.x86_64.json \
        --replace-fail '1.4.312' '1.4.321'
    '';
  });
in {
  imports = [
    ./nvuv.nix
  ];

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
        package = patchedPkg;
        # package = config.boot.kernelPackages.nvidiaPackages.beta;
        # NOTE: if a new nvidia driver isn't in nixpkgs yet, use below
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "580.76.05";
        #   sha256_64bit = "sha256-IZvmNrYJMbAhsujB4O/4hzY8cx+KlAyqh7zAVNBdl/0=";
        #   openSha256 = "sha256-xEPJ9nskN1kISnSbfBigVaO6Mw03wyHebqQOQmUg/eQ=";
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
      sessionVariables = {
        # disable vsync
        __GL_SYNC_TO_VBLANK = "0";
        # enable gsync / vrr support
        __GL_VRR_ALLOWED = "1";

        # lowest frame buffering -> lower latency
        __GL_MaxFramesAllowed = "1";
        # fix hw acceleration and native wayland on losslesscut
        __EGL_VENDOR_LIBRARY_FILENAMES = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";
        CUDA_CACHE_PATH = "$HOME/.cache/nv";
        # fix gtk4 freezes on 580
        GSK_RENDERER = "cairo";
      };
      # fix high vram usage on discord and hyprland. match with the wrapper procnames
      etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".source =
        ./50-limit-free-buffer-pool.json;
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
          # "nvidia_modeset.disable_vrr_memclk_switch=1" # stop really high memclk when vrr is in use.
        ]
        (mkIf config.hardware.nvidia.powerManagement.enable [
          "nvidia.NVreg_TemporaryFilePath=/var/tmp" # store on disk, not /tmp which is on RAM
        ])
      ];
      blacklistedKernelModules = ["nouveau"];
    };
    systemd = {
      services.nvidia-temp = mkIf cfg.exposeTemp {
        description = "NVidia GPU temperature monitoring"; # exposes.hardware temperature at /tmp/nvidia-temp for monitoring
        wantedBy = ["multi-user.target"];
        before = ["fancontrol.service"];
        script = ''
          while :; do
          	temp="$(${getExe' config.hardware.nvidia.package "nvidia-smi"} --query-gpu=temperature.gpu --format=csv,noheader,nounits)"
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
