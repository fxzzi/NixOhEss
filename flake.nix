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
      inputs.smfh.follows = "";
    };
    hyprland = {
      # url = "github:hyprwm/Hyprland";
      url = "github:fxzzi/Hyprland/ujin-cm-fixes";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        aquamarine.url = "github:gulafaran/aquamarine/atomic";
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
      url = "github:NotAShelf/stash/bb1c5dc50b20751d47c8aab41288575ea979bb1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
