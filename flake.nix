{
  description = "fazzi's NixOS config";

  outputs = {self, ...}: let
    inputs = import ./.tack;
    npinsSources = import ./npins;

    inherit (inputs.nixpkgs) lib;
    inherit (lib) genAttrs packagesFromDirectoryRecursive callPackageWith fix;

    # we only use x86_64-linux for now but this is good practice
    supportedSystems = import inputs.systems;
    forAllSystems = apply:
      genAttrs
      supportedSystems
      (system: apply inputs.nixpkgs.legacyPackages.${system});
  in {
    # our internal lib which has some generators and useful funcs
    lib = import ./lib {inherit lib inputs;};

    # hosts are configured in here
    nixosConfigurations = import ./hosts {
      inherit self inputs lib npinsSources;
    };

    # some of our pkgs depend on each other, so use fix and pass self through
    packages = forAllSystems (pkgs:
      fix (selfPkgs:
        packagesFromDirectoryRecursive {
          callPackage = callPackageWith (pkgs // selfPkgs);
          directory = ./pkgs;
        }));

    formatter = forAllSystems (pkgs: pkgs.callPackage ./fmt.nix {});
  };
}
