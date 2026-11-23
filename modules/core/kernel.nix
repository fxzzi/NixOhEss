{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.cfg.core.kernel;
  kernels = {
    latest = pkgs.linuxPackages_latest;
    lts = pkgs.linuxPackages;
    rc = pkgs.linuxKernel.packages.linux_testing;
  };
in
{
  options.cfg.core.kernel.type = mkOption {
    type = types.enum (builtins.attrNames kernels);
    default = "latest";
    description = "Selects which kernel to use";
  };
  config = {
    boot = {
      kernelPackages = kernels.${cfg.type};
      kernel.sysctl = {
        # enable sysrq / reisub
        "kernel.sysrq" = 1;
      };
    };
  };
}
