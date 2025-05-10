{
  config,
  lib,
  pkgs,
  ...
}: let
  gpuType =
    if config.cfg.gpu.nvidia.enable
    then "nvidia"
    else if config.cfg.gpu.amdgpu.enable
    then "amd"
    else "full"; # Fallback in case neither is enabled
in {
  options.cfg.cli = {
    nvtop.enable = lib.mkEnableOption "nvtop";
  };

  config = {
    hj = {
      packages = with pkgs; [
        (lib.mkIf config.cfg.cli.nvtop.enable nvtopPackages.${gpuType})
      ];
    };
  };
}
