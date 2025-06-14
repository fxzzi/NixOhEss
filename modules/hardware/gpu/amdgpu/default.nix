{
  lib,
  config,
  ...
}: {
  options.cfg.gpu.amdgpu.enable = lib.mkEnableOption "amdgpu";
  config = lib.mkIf config.cfg.gpu.amdgpu.enable {
    boot.initrd.kernelModules = ["amdgpu"];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
