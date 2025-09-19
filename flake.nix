{
  description = "fazzi's nixos + hjem conf";
  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    npins = import ./npins;
    xLib = import ./lib lib;
    mkSystem = hostName:
      lib.nixosSystem {
        specialArgs = {
          inherit inputs npins xLib hostName;
        };
        modules = [
          ./modules
          ./pkgs
          ./hosts/${hostName}
        ];
      };
    hosts = ["fazziPC" "fazziGO" "kunzozPC"];
  in {
    nixosConfigurations = lib.genAttrs hosts mkSystem;
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    systems.url = "github:nix-systems/x86_64-linux";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.smfh.follows = ""; # we use smfh from nixpkgs
    };
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
    stash = {
      url = "github:NotAShelf/stash";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
