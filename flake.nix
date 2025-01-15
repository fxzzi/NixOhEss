{
  description = "fazzi's nixos + hm conf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland/";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    nvuv.url = "gitlab:fazzi/nvuv";
    lanzaboote.url = "github:nix-community/lanzaboote";
    batmon.url = "github:notashelf/batmon";
    ags.url = "github:Aylur/ags/v1"; # i still have not updated to agsv2/astal yet lol
    agenix.url = "github:ryantm/agenix";
    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nix-formatter-pack,
    ...
  } @ inputs: let
    npins = import ./npins;
    user = "faaris";
    system = "x86_64-linux";
    nixosCommonSystem = hostName:
      nixpkgs.lib.nixosSystem {
        inherit system;
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
  in {
    nixosConfigurations = {
      fazziPC = nixosCommonSystem "fazziPC";
      fazziGO = nixosCommonSystem "fazziGO";
    };

    # Add the formatter output
    formatter.x86_64-linux = nix-formatter-pack.lib.mkFormatter {
      inherit nixpkgs system;

      config = {
        tools = {
          deadnix.enable = true;
          alejandra.enable = true;
          statix.enable = true;
        };
      };
    };
  };
}
