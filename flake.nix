{
  description = "fazzi's NixOS config";
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      imports = [
        ./hosts
        ./modules
        ./parts
      ];
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      # PR just before hyprpaper ipc format changed
      url = "github:hyprwm/Hyprland/9b1891e4765e2c5b84c8c61725e3973ca9940e05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
        ndg.follows = "";
      };
    };
    stash = {
      url = "github:NotAShelf/stash";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watt = {
      url = "github:NotAShelf/watt/v1-dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
