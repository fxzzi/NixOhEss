{
  self,
  inputs,
  pins,
  withSystem,
  lib,
  ...
}: let
  inherit (lib) genAttrs nixosSystem filterAttrs;
  inherit (builtins) attrNames readDir;

  # Filter readDir to only include directories
  # This avoids pulling in this file (default.nix) as a host
  dirs = filterAttrs (_: type: type == "directory") (readDir ./.);

  mkSystem = hostName: let
    # To be able to access some flake-parts features, like pre-selected
    # platform for inputs and self (inputs', self', etc), we need to enter
    # the withSystem context. This requires, as expected, a system architecture.
    # So, we can put the architecture in a seperate file per host, and use it
    # here. This gives us some fancy features. For example:
    # instead of `inputs.<input>.packages.${pkgs.stdenv.hostPlatform.system}.default`,
    # we can just do `inputs'.<input>.packages.default`.
    # instead of `self.packages.${pkgs.stdenv.hostPlatform.system}.default`,
    # we can just do `self'.packages.default`.
    system = import ./${hostName}/system.nix;
  in
    withSystem system ({
      inputs',
      self',
      ...
    }:
      nixosSystem {
        specialArgs = {
          inherit self self' inputs inputs' hostName pins;
        };
        modules = [
          # we exposed our ${self}/modules directory as a nixosModule
          self.nixosModules.default
          ./${hostName}
        ];
      });
in {
  flake.nixosConfigurations = genAttrs (attrNames dirs) mkSystem;
}
