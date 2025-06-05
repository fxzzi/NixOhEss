{
  lib,
  config,
  pkgs,
  ...
}: let
  # NOTE: Workaround https://gitlab.freedesktop.org/drm/amd/-/issues/4238
  # remove when reverted upstream.
  amdgpu-kernel-module = pkgs.callPackage ./amdgpu-kernel-module.nix {
    # Make sure the module targets the same kernel as your system is using.
    inherit (config.boot.kernelPackages) kernel;
  };
in {
  options.cfg.gpu.amdgpu.enable = lib.mkEnableOption "amdgpu";
  config = lib.mkIf config.cfg.gpu.amdgpu.enable {
    boot.extraModulePackages = [
      (amdgpu-kernel-module.overrideAttrs {
        patches = [./amdgpu-revert.patch];
      })
    ];
    boot.initrd.kernelModules = ["amdgpu"];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
