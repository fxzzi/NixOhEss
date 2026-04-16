{
  self,
  inputs,
}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) fix genAttrs packagesFromDirectoryRecursive;
  pins = import ./npins;

  # we only use x86_64-linux for now but this is good practice
  supportedSystems = import inputs.systems;
  forAllSystems = apply:
    genAttrs
    supportedSystems
    (system: apply inputs.nixpkgs.legacyPackages.${system});
in {
  # our private lib which has some generators and useful funcs
  lib = import ./lib lib;

  nixosConfigurations = import ./nixosConfigurations.nix {
    inherit self inputs pins lib;
  };

  packages = forAllSystems (pkgs:
    # some of our pkgs depend on each other, so use fix and pass self through
      fix (selfPkgs:
        # recursively callPackage every drv in ./pkgs
          packagesFromDirectoryRecursive {
            # pass through our npins sources as well
            callPackage = pkgs.lib.callPackageWith (pkgs // selfPkgs // {inherit pins;});
            directory = ./pkgs;
          }));

  formatter = forAllSystems (pkgs: import ./fmt.nix {inherit pkgs;});
}
