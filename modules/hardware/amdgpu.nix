{
  lib,
  config,
  self,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.hardware.amdgpu;
in {
  options.cfg.hardware.amdgpu.enable = mkEnableOption "amdgpu";
  config = mkIf cfg.enable {
    # only used patched amdgpu on kernels >= 6.17
    boot.extraModulePackages = mkIf (config.boot.kernelPackages.kernelAtLeast "6.17") [
      (self.packages.${pkgs.stdenv.hostPlatform.system}.amdgpu-kernel-module.override {
        inherit (config.boot.kernelPackages) kernel;
      })
    ];
    hardware = {
      # early load / early kms
      amdgpu.initrd.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
