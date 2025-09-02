{
  description = "fazzi's nixos + hjem conf";
  outputs = inputs: let
    forEachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
    pkgsForEach = inputs.nixpkgs.legacyPackages;
    npins = import ./npins;
    xLib = import ./lib inputs.nixpkgs.lib;

    mkSystem = hostName:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs npins xLib hostName;
        };
        modules = [
          ./modules
          ./hosts/${hostName}
        ];
      };
    hosts = ["fazziPC" "fazziGO" "kunzozPC"];
  in {
    nixosConfigurations = inputs.nixpkgs.lib.genAttrs hosts mkSystem;
    packages = forEachSystem (system: import ./pkgs {pkgs = pkgsForEach.${system};});
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
