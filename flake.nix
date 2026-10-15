{
  description = "fazzi's NixOS config";

  outputs =
    { self }:
    let
      inputs = import ./.tack;

      inherit (inputs.nixpkgs) lib;
      inherit (lib) genAttrs packagesFromDirectoryRecursive callPackageWith;

      forAllSystems = genAttrs (import inputs.systems);
      pkgsFor = system: inputs.nixpkgs.legacyPackages.${system};
    in
    {
      # our internal lib which has some generators and useful funcs
      lib = import ./lib { inherit lib inputs; };

      nixosModules.default = self.lib.nixFilesInRecursive ./modules;

      # hosts are configured in here
      nixosConfigurations = import ./hosts {
        inherit self inputs lib;
      };

      packages = forAllSystems (
        system:
        packagesFromDirectoryRecursive {
          callPackage = callPackageWith ((pkgsFor system) // self.packages.${system});
          directory = ./pkgs;
        }
      );

      formatter = forAllSystems (system: (pkgsFor system).callPackage ./fmt.nix { });
    };
}
