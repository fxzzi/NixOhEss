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
  hostnames = filterAttrs (_: type: type == "directory") (readDir ./.);

  # To be able to access some flake-parts features, like pre-selected
  # platform for inputs and self (inputs', self', etc), we need to enter
  # the withSystem context. This requires, as expected, a system architecture.
  # All of my hosts are x86_64-linux for now.
  #
  # This gives us some fancy features. For example:
  # instead of `inputs.<input>.packages.${pkgs.stdenv.hostPlatform.system}.default`,
  # we can just do `inputs'.<input>.packages.default`.
  # instead of `self.packages.${pkgs.stdenv.hostPlatform.system}.default`,
  # we can just do `self'.packages.default`.
  mkSystem = hostName:
    withSystem "x86_64-linux" ({
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
  flake.nixosConfigurations = genAttrs (attrNames hostnames) mkSystem;
}
