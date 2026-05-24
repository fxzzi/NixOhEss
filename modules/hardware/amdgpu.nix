{
  lib,
  config,
  pkgs,
  pins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.hardware.amdgpu;
in {
  options.cfg.hardware.amdgpu.enable = mkEnableOption "amdgpu";
  config = mkIf cfg.enable {
    hardware = {
      amdgpu = {
        # early load / early kms
        initrd.enable = true;
        # overclocking / undervolting
        overdrive = {
          # disable on laptops
          enable = !config.cfg.core.isLaptop;
          # just enable oc stuff and nothing more
          ppfeaturemask = "0xfff7ffff";
        };
      };
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
    # enable HIP for packages which use it
    # (blender for the most part lol)
    nixpkgs.config.hipSupport = true;
    environment = {
      sessionVariables = {
        # Increase AMD's shader cache size to xGB
        MESA_SHADER_CACHE_MAX_SIZE = "12G";
      };
      systemPackages = [
        (pkgs.callPackage "${pins.nix-gaming}/pkgs/low-latency-layer" {
          inherit pins;
        })
      ];
    };
  };
}
