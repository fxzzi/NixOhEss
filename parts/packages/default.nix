{
  inputs,
  pins,
  ...
}: let
  inherit (inputs.nixpkgs.lib) packagesFromDirectoryRecursive fix;
in {
  perSystem = {pkgs, ...}: {
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
