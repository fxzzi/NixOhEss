{
  description = "fazzi's NixOS config";

  outputs = inputs @ {self, ...}: let
    inherit (inputs.nixpkgs) lib;
    inherit (lib) genAttrs packagesFromDirectoryRecursive filterAttrs isDerivation;
    pins = import ./npins;

    # we only use x86_64-linux for now but this is good practice
    supportedSystems = import inputs.systems;
    forAllSystems = apply:
      genAttrs
      supportedSystems
      (system: apply inputs.nixpkgs.legacyPackages.${system});
  in {
    # our private lib which has some generators and useful funcs
    lib = import ./lib lib;

    # hosts are configured in here
    nixosConfigurations = import ./hosts.nix {
      inherit self inputs pins lib;
    };

    # some of our packages rely on each other, so we need to
    # pass through newScope to allow for this. This litters
    # our packages output with a few things which aren't drvs.
    # so filter them out.
    packages = forAllSystems (
      pkgs:
        filterAttrs (_: isDerivation) (
          packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage newScope;
            directory = ./pkgs;
          }
        )
    );

    formatter = forAllSystems (pkgs: import ./fmt.nix {inherit pkgs;});
  };

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
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        aquamarine.url = "github:gulafaran/aquamarine/commit";
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
