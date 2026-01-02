{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.hardware.amdgpu;
in {
  options.cfg.hardware.amdgpu.enable = mkEnableOption "amdgpu";
  config = mkIf cfg.enable {
    hardware = {
      # early load / early kms
      amdgpu.initrd.enable = true;
      # overclocking / undervolting
      amdgpu.overdrive.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
    # enable HIP for packages which use it
    # (blender for the most part lol)
    nixpkgs.config.hipSupport = true;
  };
}
