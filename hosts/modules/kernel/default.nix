{
  config,
  pkgs,
  lib,
  ...
}: let
  kernelType =
    if config.kernel.type == "zen"
    then pkgs.linuxKernel.packages.linux_zen
    else if config.kernel.type == "latest"
    then pkgs.linuxPackages_latest
    else throw "Unsupported kernel type. Use 'zen' or 'latest'.";
in {
  options.kernel.type = lib.mkOption {
    type = lib.types.enum [
      "latest"
      "zen"
    ];
    default = "latest";
    description = "Selects which kernel you would like to use: 'latest' or 'zen'.";
  };
  options.kernel.higherMaxMapCount = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable higher vm.max_map_count value for better gaming performance.";
  };
  config = {
    boot = {
      kernelPackages = kernelType; # Set kernel based on selection
      kernel.sysctl = lib.mkIf config.kernel.higherMaxMapCount {
        # Increase vm.max_map_count if enabled
        "vm.max_map_count" = 2147483642;
      };
    };
  };
  imports = [
    ./zenpower
    ./xone
    ./v4l2
  ];
}
