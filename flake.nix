{
  description = "fazzi's NixOS config";

  # no flake-parts :)
  outputs = inputs @ {self, ...}: import ./parts {inherit self inputs;};

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    # my packages which are intended for public use are available here
    azzipkgs = {
      url = "gitlab:fazzi/azzipkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "";
    };
    hyprland = {
      # url = "github:hyprwm/Hyprland";
      url = "github:UjinT34/Hyprland/refactor-8-cm-automation";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        aquamarine = {
          url = "github:gulafaran/aquamarine/commit";
          inputs = {
            nixpkgs.follows = "nixpkgs";
            systems.follows = "systems";
            hyprutils.follows = "hyprland/hyprutils";
          };
        };
      };
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-compat.follows = "";
        ndg.follows = "";
      };
    };
    stash = {
      url = "github:NotAShelf/stash";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # for lanzaboote
    crane.follows = "stash/crane";
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
