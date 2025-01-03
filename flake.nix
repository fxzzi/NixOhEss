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

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.faarnixOS = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hardware-configuration.nix
        ./modules/default.nix
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.users.faaris = import ./hm/default.nix;
        }
      ];
    };
  };
}
