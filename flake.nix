{
  description = "fazzi's nixos + hm conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-olympus.url = "github:Petingoso/nixpkgs/olympus";
    nixpkgs-sgdboop.url = "github:Saturn745/nixpkgs/sgdboop-init";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprsunset = {
      url = "github:outfoxxed/hyprsunset/ctm-blocked";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvuv = {
      url = "gitlab:fazzi/nvuv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    batmon = {
      url = "github:notashelf/batmon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags/v1"; # still on v1 lmfao
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = ""; # don't need darwin deps
      };
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tokyo-night-linux = {
      url = "github:stronk-dev/Tokyo-Night-Linux";
      flake = false;
    };
    walls = {
      url = "gitlab:fazzi/walls";
      flake = false;
    };
    startpage = {
      url = "gitlab:fazzi/startpage";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    npins = import ./npins;
    user = "faaris";
    system = "x86_64-linux";
    nixosCommonSystem = hostName:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            inputs
            npins
            user
            hostName
            ;
        };
        modules = [
          ./hosts
        ];
      };
  in {
    nixosConfigurations = {
      fazziPC = nixosCommonSystem "fazziPC";
      fazziGO = nixosCommonSystem "fazziGO";
    };
  };
}
