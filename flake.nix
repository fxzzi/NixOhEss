{
  description = "fazzi's nixos conf";
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) fix genAttrs nixosSystem packagesFromDirectoryRecursive;

    pins = import ./npins;
    xLib = import ./lib nixpkgs.lib;
    forEachSystem = genAttrs (import inputs.systems);
    pkgsForEach = nixpkgs.legacyPackages;

    mkSystem = hostName:
      nixosSystem {
        specialArgs = {inherit self inputs pins xLib hostName;};
        modules = [
          ./modules
          ./hosts/${hostName}
        ];
      };

    mkPackages = system: let
      pkgs = pkgsForEach.${system};
    in
      # some of our pkgs depend on each other, so use fix and pass self through
      fix (self:
        # recursively callPackage every drv in ./pkgs
          packagesFromDirectoryRecursive {
            # pass through our npins sources as well
            callPackage = pkgs.lib.callPackageWith (pkgs // self // {inherit pins;});
            directory = ./pkgs;
          });
  in {
    # parse all dirs in ./hosts, generate a nixosConfiguration for each
    nixosConfigurations = genAttrs (builtins.attrNames (builtins.readDir ./hosts)) mkSystem;
    packages = forEachSystem mkPackages;
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        ndg.follows = ""; # sorry, docs!
      };
    };
    hyprland = {
      # url = "github:hyprwm/Hyprland";
      url = "github:gulafaran/Hyprland/fifo";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    nvf = {
      url = "github:NotAShelf/nvf/v0.8";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    stash = {
      # pin to 0.3.1 for now
      url = "github:NotAShelf/stash/v0.3.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
