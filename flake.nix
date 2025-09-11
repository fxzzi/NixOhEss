{
  description = "fazzi's nixos + hjem conf";
  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    npins = import ./npins;
    xLib = import ./lib lib;

    mkSystem = hostName:
      lib.nixosSystem {
        specialArgs = {
          inherit inputs npins xLib hostName;
        };
        modules = [
          ./modules
          ./pkgs
          ./hosts/${hostName}
        ];
      };
    hosts = ["fazziPC" "fazziGO" "kunzozPC"];
  in {
    nixosConfigurations = lib.genAttrs hosts mkSystem;
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    systems.url = "github:nix-systems/x86_64-linux";
    hyprland = {
      # url = "github:hyprwm/Hyprland";
      url = "github:ikalco/Hyprland/fix_tearing_with_ds";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
