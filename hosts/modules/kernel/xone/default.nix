{
  config,
  lib,
  npins,
  ...
}: {
  options.cfg.kernel.xone.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the xone kernel driver, for connecting Xbox controllers wirelessly.";
  };
  config = lib.mkIf config.cfg.kernel.xone.enable {
    hardware.xone.enable = true;
    # lets assume you want xbox360 controllers to still work.
    hardware.xpad-noone.enable = true;
    boot = {
      kernelModules = ["xpad"];
    };
  };
}
