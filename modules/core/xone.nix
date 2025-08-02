{
  config,
  lib,
  ...
}: {
  options.cfg.core.kernel.xone.enable = lib.mkEnableOption "xone";
  config = lib.mkIf config.cfg.core.kernel.xone.enable {
    hardware.xone.enable = true;
    boot = {
      kernelModules = ["xpad"];
    };
  };
}
