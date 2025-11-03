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
    # early load / early kms
    hardware.amdgpu.initrd.enable = true;
    boot.extraModulePackages = [
      (self.packages.${pkgs.stdenv.hostPlatform.system}.amdgpu-kernel-module.override {
        inherit (config.boot.kernelPackages) kernel;
      })
    ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
