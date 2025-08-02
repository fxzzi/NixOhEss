{
  lib,
  config,
  ...
}: {
  options.cfg.hardware.amdgpu.enable = lib.mkEnableOption "amdgpu";
  config = lib.mkIf config.cfg.hardware.amdgpu.enable {
    # early load / early kms
    boot.initrd.kernelModules = ["amdgpu"];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
