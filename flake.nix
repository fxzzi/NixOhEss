{
  description = "fazzi's nixos conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland/";
    hyprland-contrib.url = "github:hyprwm/contrib";
  };
  outputs = {self, ...} @ inputs: {
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
      ];
    };
  };
}
