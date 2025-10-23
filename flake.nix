{
  description = "fazzi's nixos conf";
  outputs = {self, ...} @ inputs: let
    inherit (inputs) nixpkgs;
    inherit (nixpkgs) lib;
    inherit (lib) genAttrs nixosSystem packagesFromDirectoryRecursive;
    pins = import ./npins;
    xLib = import ./lib lib;
    systems = import inputs.systems;
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;
    mkSystem = hostName:
      nixosSystem {
        specialArgs = {
          inherit self inputs pins xLib hostName;
        };
        modules = [
          ./modules
          ./hosts/${hostName}
        ];
      };
    hosts = ["fazziPC" "fazziGO" "kunzozPC"];
  in {
    nixosConfigurations = genAttrs hosts mkSystem;
    packages = forEachSystem (system: let
      pkgs = pkgsForEach.${system};
    in
      packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        newScope = extra: pkgs.newScope (extra // {inherit pins;});
        directory = ./pkgs;
      });
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    hjem = {
      # latest master is broken
      url = "github:feel-co/hjem";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        ndg.follows = ""; # sorry, docs!
      };
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    nvf = {
      url = "github:NotAShelf/nvf/ea3ee477fa1814352b30d114f31bf4895eed053e";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    stash = {
      url = "github:NotAShelf/stash/v0.3.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
