{
  config,
  lib,
  ...
}: {
  options.cfg.kernel.xone.enable = lib.mkEnableOption "xone";
  config = lib.mkIf config.cfg.kernel.xone.enable {
    hardware.xone.enable = true;
    boot = {
      kernelModules = ["xpad"];
    };
  };
}
