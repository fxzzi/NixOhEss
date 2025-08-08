{
  description = "fazzi's nixos + hjem conf";
  outputs = inputs: let
    npins = import ./npins;
    xLib = import ./lib inputs.nixpkgs.lib;

    mkSystem = hostName:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs npins xLib hostName;
        };
        modules = [
          ./modules
          ./hosts/${hostName}
        ];
      };
    hosts = ["fazziPC" "fazziGO" "kunzozPC"];
  in {
    nixosConfigurations = inputs.nixpkgs.lib.genAttrs hosts mkSystem;
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    systems.url = "github:nix-systems/x86_64-linux";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
