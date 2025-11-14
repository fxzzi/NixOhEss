{
  description = "fazzi's nixos conf";
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
    nixpkgs.url = "github:NixOS/nixpkgs/9da7f1cf7f8a6e2a7cb3001b048546c92a8258b4";
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
      url = "github:hyprwm/Hyprland";
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
      url = "github:NotAShelf/watt/v1-dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
