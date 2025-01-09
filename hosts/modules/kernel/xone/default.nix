{
  config,
  lib,
  ...
}: {
  options.kernel.xone.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the xone kernel driver, for connecting Xbox controllers wirelessly.";
  };
  config = lib.mkIf config.kernel.xone.enable {
    hardware.xone.enable = true;
    boot.extraModulePackages = with config.boot.kernelPackages; [xone];
  };
}
