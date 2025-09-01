{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cudaBoostBypass = pkgs.callPackage ./package.nix {};
in {
  config = mkIf config.cfg.hardware.nvidia.enable {
    nixpkgs.overlays = [
      (_: _: {
        inherit cudaBoostBypass;
      })
    ];
  };
}
