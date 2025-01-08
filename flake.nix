{
  description = "fazzi's nixos + hm conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland/";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    nvuv.url = "gitlab:fazzi/nvuv";
    nixpkgs-olympus.url = "github:Petingoso/nixpkgs/olympus";
    nixpkgs-sgdboop.url = "github:Saturn745/nixpkgs/sgdboop-init";
    lanzaboote.url = "github:nix-community/lanzaboote";
    batmon.url = "github:fxzzi/batmon/use-default.target";
    ags.url = "github:Aylur/ags/v1"; # i still have not updated to ags v1 yet lol
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      npins = import ./npins;
      user = "faaris";
      nixosCommonSystem =
        hostName:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
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
    in
    {
      nixosConfigurations = {
        fazziPC = nixosCommonSystem "fazziPC";
        fazziGO = nixosCommonSystem "fazziGO";
      };
    };
}
