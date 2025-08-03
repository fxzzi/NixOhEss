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
    # early load / early kms
    boot.initrd.kernelModules = ["amdgpu"];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
