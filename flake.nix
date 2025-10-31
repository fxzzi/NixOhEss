{
  description = "fazzi's nixos conf";
  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs = {
        pins = import ./parts/npins;
      };
    } {
      systems = import inputs.systems;
      imports = [
        ./hosts
        ./parts/packages
        ./parts/fmt.nix
      ];
      flake = {
        lib = import ./parts/lib inputs.nixpkgs.lib;
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
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
      url = "github:NotAShelf/stash";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
