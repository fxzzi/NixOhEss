{
  description = "fazzi's NixOS config";

  outputs =
    { self }:
    let
      inputs = import ./.tack;

      inherit (inputs.nixpkgs) lib;
      inherit (lib) packagesFromDirectoryRecursive callPackageWith;

      # all my systems are x86_64-linux
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      # our internal lib which has some generators and useful funcs
      lib = import ./lib { inherit lib inputs; };

      nixosModules.default = self.lib.listRecursive ./modules;

      # hosts are configured in here
      nixosConfigurations = import ./hosts {
        inherit self inputs lib;
      };

      packages.${system} = packagesFromDirectoryRecursive {
        callPackage = callPackageWith (pkgs // self.packages.${system});
        directory = ./pkgs;
      };

      formatter.${system} = pkgs.callPackage ./fmt.nix { };
    };
}
