{
  inputs,
  pins,
  ...
}: let
  inherit (inputs.nixpkgs.lib) packagesFromDirectoryRecursive fix;
in {
  perSystem = {
    pkgs,
    system,
    config,
    ...
  }: {
    # Configure nixpkgs locally and expose it as <flakeRef>.legacyPackages.
    # This will then be consumed to override flake-parts' pkgs argument
    # to make sure pkgs instances in flake-parts modules are all referring
    # to the same configuration instance - this one.
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    _module.args = {
      # Unify all instances of nixpkgs into a single `pkgs` set
      # Wthat includes our own overlays within `perSystem`. This
      # is not done by flake-parts, so we do it ourselves.
      # See:
      #  <https://github.com/hercules-ci/flake-parts/issues/106#issuecomment-1399041045>
      pkgs = config.legacyPackages;
    };
    packages =
      # some of our pkgs depend on each other, so use fix and pass self through
      fix (self:
        # recursively callPackage every drv in ./pkgs
          packagesFromDirectoryRecursive {
            # pass through our npins sources as well
            callPackage = pkgs.lib.callPackageWith (pkgs // self // {inherit pins;});
            directory = ./packages;
          });
  };
}
