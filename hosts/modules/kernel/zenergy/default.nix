{
  config,
  lib,
  ...
}: {
  options.cfg.kernel.zenergy.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables zenergy and configures kernel modules to make it work.";
  };
  config = lib.mkIf config.cfg.kernel.zenergy.enable {
    boot = {
      kernelModules = ["nct6775"];
      extraModulePackages = with config.boot.kernelPackages; [zenergy]; # zenergy for ryzen sensors
      # blacklistedKernelModules = ["k10temp"]; # Blacklist k10temp because zenergy provides it
    };
  };
}
