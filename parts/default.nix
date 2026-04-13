{
  self,
  inputs,
}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) fix genAttrs packagesFromDirectoryRecursive;
  pins = import ./npins;

  # we only use x86_64-linux for now but this is good practice
  systems = import inputs.systems;
  genSystems = genAttrs systems;
  pkgsForEach = inputs.nixpkgs.legacyPackages;
in {
  # our private lib which has some generators and useful funcs
  lib = import ./lib lib;

  nixosConfigurations = import ./nixosConfigurations.nix {
    inherit self inputs pins lib;
  };

  packages = genSystems (system: let
    pkgs = pkgsForEach.${system};
  in
    # some of our pkgs depend on each other, so use fix and pass self through
    fix (selfPkgs:
      # recursively callPackage every drv in ./pkgs
        packagesFromDirectoryRecursive {
          # pass through our npins sources as well
          callPackage = pkgs.lib.callPackageWith (pkgs // selfPkgs // {inherit pins;});
          directory = ./pkgs;
        }));

  formatter = genSystems (system: import ./fmt.nix {pkgs = pkgsForEach.${system};});
}
