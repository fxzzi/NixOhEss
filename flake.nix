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
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      npins = import ./npins;
			# you can change your username here :)
			user = "faaris";
    in
    {
      nixosConfigurations.fazziPC = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs npins user; };
        modules = [
          ./machines/fazziPC
          ./overlays
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.${user} = import ./home;
              extraSpecialArgs = { inherit inputs npins user; };
            };
          }
        ];
      };
      nixosConfigurations.fazziGO = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs npins user; };
        modules = [
          ./machines/fazziGO
          ./overlays
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak";
              users.${user} = import ./home;
              extraSpecialArgs = { inherit inputs npins user; };
            };
          }
        ];
      };
    };
}
