{
  description = "fazzi's nixos conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland/";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    nvuv.url = "gitlab:fazzi/nvuv";
    nixpkgs-olympus.url = "github:Petingoso/nixpkgs/olympus";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixpkgs-olympus,
      ...
    }:
    let
      npins = import ./npins;
    in
    {
      nixosConfigurations.fazziPC = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs npins; };
        modules = [
          ./machines/fazziPC
          ./overlays
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.faaris = import ./home;
              extraSpecialArgs = { inherit inputs npins; };
            };
          }
        ];
      };
      nixosConfigurations.fazziGO = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs npins; };
        modules = [
          ./machines/fazziGO
          ./overlays
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.faaris = import ./home;
              extraSpecialArgs = { inherit inputs npins; };
            };
          }
        ];
      };
    };
}
