{
  description = "fazzi's nixos + hm conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    nvuv.url = "gitlab:fazzi/nvuv";
    lanzaboote.url = "github:nix-community/lanzaboote";
    batmon.url = "github:notashelf/batmon";
    ags.url = "github:Aylur/ags/v1"; # still on v1 lmfao
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
          ./overlays
          inputs.home-manager.nixosModules.home-manager
        ];
      };
  in {
    nixosConfigurations = {
      fazziPC = nixosCommonSystem "fazziPC";
      fazziGO = nixosCommonSystem "fazziGO";
    };
  };
}
