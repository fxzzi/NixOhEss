{
  description = "fazzi's nixos conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland/";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    nvuv.url = "gitlab:fazzi/nvuv";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: let
    npins = import ./npins;
  in {
    nixosConfigurations.faarnixOS = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs npins; };
      modules = [
        ./hardware-configuration.nix
        ./modules
				./overlays
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            users.faaris = import ./hm;
            extraSpecialArgs = { inherit inputs npins; };
          };
        }
      ];
    };
  };
}
