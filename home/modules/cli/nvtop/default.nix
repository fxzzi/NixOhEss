{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  gpuType =
    if osConfig.cfg.gpu.nvidia.enable
    then "nvidia"
    else if osConfig.cfg.gpu.amdgpu.enable
    then "amd"
    else "full"; # Fallback in case neither is enabled
in {
  options.cfg.cli = {
    nvtop.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the nvtop gpu monitoring cli";
    };
  };

  config = {
    home.packages = with pkgs; [
      (lib.mkIf config.cfg.cli.nvtop.enable nvtopPackages.${gpuType})
    ];
  };
}
