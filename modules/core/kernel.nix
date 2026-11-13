{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.cfg.core.kernel;
  kernelType =
    if cfg.type == "latest" then
      pkgs.linuxPackages_latest
    else if cfg.type == "lts" then
      pkgs.linuxPackages
    else if cfg.type == "rc" then
      pkgs.linuxKernel.packages.linux_testing
    else
      throw "Unsupported kernel type.";
in
{
  options.cfg.core.kernel.type = mkOption {
    type = types.enum [
      "latest"
      "lts"
      "rc"
    ];
    default = "latest";
    description = "Selects which kernel to use";
  };
  config = {
    boot = {
      kernelPackages = kernelType; # Set kernel based on selection
      kernel.sysctl = {
        # enable sysrq / reisub
        "kernel.sysrq" = 1;
      };
    };
  };
}
