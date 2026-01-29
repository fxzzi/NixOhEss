{
  inputs,
  pins,
  lib,
  ...
}: let
  inherit (lib) packagesFromDirectoryRecursive fix;
in {
  _module.args = {
    # Pass `pins` to flake-parts' module args. This allows
    # parts of the module system to refer to them in a more concise
    # way than importing them directly.
    pins = import ./npins;
  };
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args = {
      # Unify all instances of nixpkgs into a single `pkgs` set
      # this is not done by flake-parts, so we do it ourselves.
      # See:
      #  <https://github.com/hercules-ci/flake-parts/issues/106#issuecomment-1399041045>
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
    packages =
      # some of our pkgs depend on each other, so use fix and pass self through
      fix (self:
        # recursively callPackage every drv in ./pkgs
          packagesFromDirectoryRecursive {
            # pass through our npins sources as well
            callPackage = pkgs.lib.callPackageWith (pkgs // self // {inherit pins;});
            directory = ./pkgs;
          });
  };

  imports = [
    ./lib
    ./fmt.nix
  ];
}
