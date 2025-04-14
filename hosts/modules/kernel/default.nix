{
  config,
  pkgs,
  lib,
  ...
}: let
  kernelType =
    if config.cfg.kernel.type == "latest"
    then pkgs.linuxPackages_latest
    else if config.cfg.kernel.type == "lts"
    then pkgs.linuxPackages
    else if config.cfg.kernel.type == "zen"
    then pkgs.linuxKernel.packages.linux_zen
    else if config.cfg.kernel.type == "xanmod"
    then pkgs.linuxKernel.packages.linux_xanmod_latest
    else if config.cfg.kernel.type == "lqx"
    then pkgs.linuxKernel.packages.linux_lqx
    else throw "Unsupported kernel type.";
in {
  options.cfg.kernel.type = lib.mkOption {
    type = lib.types.enum [
      "latest"
      "zen"
      "xanmod"
      "lts"
    ];
    default = "latest";
    description = "Selects which kernel you would like to use: 'latest' or 'zen'.";
  };
  options.cfg.kernel.higherMaxMapCount = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable higher vm.max_map_count value for better gaming performance.";
  };
  config = {
    boot = {
      kernelPackages = kernelType; # Set kernel based on selection
      kernel.sysctl = lib.mkIf config.cfg.kernel.higherMaxMapCount {
        # Increase vm.max_map_count if enabled
        "vm.max_map_count" = 2147483642;
      };
    };
  };
  imports = [
    ./zenpower
    ./xone
    ./v4l2
    ./zenergy
  ];
}
