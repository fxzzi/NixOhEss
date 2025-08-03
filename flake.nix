{
  description = "fazzi's nixos + hjem conf";

  outputs = inputs: let
    npins = import ./npins;
    xLib = import ./lib inputs.nixpkgs.lib;

    mkSystem = hostName: {user}:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs npins xLib hostName user;
        };
        modules = [
          ./modules
          ./hosts/${hostName}
        ];
      };

    # adding a host? Add a hostname and username here
    # then, have a gander at ./hosts
    hosts = {
      fazziPC.user = "faaris";
      fazziGO.user = "faaris";
      kunzozPC.user = "kunzoz";
    };
  in {
    nixosConfigurations = builtins.mapAttrs mkSystem hosts;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        smfh.follows = ""; # we use smfh from nixpkgs
      };
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    nvuv = {
      url = "gitlab:fazzi/nvuv";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = ""; # ew, home-manager
        darwin.follows = ""; # ew, apple
      };
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    creamlinux = {
      # FIXME: pin to older release until i have the time to update the flake
      url = "github:Novattz/creamlinux-installer/17ad517a459f1a41a40bef2642ee952859147ab5";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
