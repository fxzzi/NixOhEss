{ config, lib, ... }:
{
	options.kernel.zenpower.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables zenpower and configures kernel modules to make it work.";
  };
  config = lib.mkIf config.kernel.zenpower.enable {
    boot = {
      kernelModules = [ "nct6775" ];
      extraModulePackages = with config.boot.kernelPackages; [ zenpower ]; # zenpower for ryzen sensors
      blacklistedKernelModules = [ "k10temp" ]; # Blacklist k10temp because zenpower provides it
    };
  };
}
