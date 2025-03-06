{
  lib,
  config,
  ...
}: {
  options.cfg.gpu.amdgpu.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the amdgpu configuration for dedicated and integrated AMD gpus.";
  };
  config = lib.mkIf config.cfg.gpu.amdgpu.enable {
    boot.initrd.kernelModules = ["amdgpu"];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
