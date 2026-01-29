{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.cfg.core.kernel;
  kernelType =
    if cfg.type == "latest"
    then pkgs.linuxPackages_latest
    else if cfg.type == "lts"
    then pkgs.linuxPackages
    else if cfg.type == "zen"
    then pkgs.linuxKernel.packages.linux_zen
    else throw "Unsupported kernel type.";
in {
  options.cfg.core.kernel.type = mkOption {
    type = types.enum [
      "latest"
      "zen"
      "lts"
    ];
    default = "latest";
    description = "Selects which kernel to use";
  };
  config = {
    boot = {
      kernelPackages = kernelType; # Set kernel based on selection
      kernel.sysctl = {
        # Increase vm.max_map_count for gaming
        "vm.max_map_count" = 2147483642;
      };
    };
  };
}
