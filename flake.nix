{
  description = "fazzi's NixOS config";

  outputs = inputs @ {self, ...}: let
    inherit (inputs.nixpkgs) lib;
    inherit (lib) genAttrs packagesFromDirectoryRecursive callPackageWith fix;
    pins = import ./npins;

    # we only use x86_64-linux for now but this is good practice
    supportedSystems = import inputs.systems;
    forAllSystems = apply:
      genAttrs
      supportedSystems
      (system: apply inputs.nixpkgs.legacyPackages.${system});
  in {
    # our internal lib which has some generators and useful funcs
    lib = import ./lib {inherit lib inputs;};

    # hosts are configured in here
    nixosConfigurations = import ./hosts {
      inherit self inputs pins lib;
    };

    # some of our pkgs depend on each other, so use fix and pass self through
    packages = forAllSystems (pkgs:
      fix (selfPkgs:
        packagesFromDirectoryRecursive {
          # pass through our npins sources
          callPackage = callPackageWith (pkgs // selfPkgs // {inherit pins inputs;});
          directory = ./pkgs;
        }));

    formatter = forAllSystems (pkgs: pkgs.callPackage ./fmt.nix {});
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
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane.url = "github:ipetkov/crane";
    stash = {
      url = "github:NotAShelf/stash";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
    };
    tuigreet = {
      url = "github:NotAShelf/tuigreet";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
    };
  };
}
