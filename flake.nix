{
  description = "fazzi's nixos + hjem conf";
  outputs = inputs: let
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
  };
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
}
