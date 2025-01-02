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
  outputs = {self, nixpkgs, home-manager, ...} @ inputs: {
    nixosConfigurations.faarnixOS = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [ 
        ./modules/audio.nix
        ./modules/boot.nix
        ./modules/cachix.nix
        ./modules/fancontrol.nix
        ./modules/fonts.nix
        ./modules/gaming.nix
        ./modules/networking.nix
        ./modules/nvidia.nix
        ./modules/packages.nix
        ./modules/services.nix
        ./modules/state.nix
        ./modules/user.nix
        ./modules/wayland.nix
        ./modules/hardware-configuration.nix
				home-manager.nixosModules.home-manager
				{
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            # home-manager.users.faaris = import ./hm/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
        }
      ];
    };
  };
}

