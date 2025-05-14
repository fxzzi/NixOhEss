{
  description = "fazzi's nixos + hjem conf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-olympus.url = "github:Petingoso/nixpkgs/olympus";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprgraphics.follows = "hyprland/hyprgraphics";
      };
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprgraphics.follows = "hyprland/hyprgraphics";
      };
    };
    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprutils.follows = "hyprland/hyprutils";
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };
    ags = {
      url = "github:Aylur/ags/v1"; # still on v1 lmfao
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nvuv = {
      url = "gitlab:fazzi/nvuv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    batmon = {
      url = "github:notashelf/batmon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = ""; # ew home-manager
        darwin.follows = ""; # don't need darwin deps
      };
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    creamlinux = {
      url = "github:Novattz/creamlinux-installer";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    # non-flake inputs
    tokyo-night-linux = {
      url = "github:stronk-dev/Tokyo-Night-Linux";
      flake = false;
    };
    walls = {
      url = "gitlab:fazzi/walls";
      flake = false;
    };
    startpage = {
      url = "gitlab:fazzi/startpage";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    npins = import ./npins;
    lib' = import ./lib inputs.nixpkgs.lib;

    nixosCommonSystem = {
      hostName,
      user,
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs npins hostName user lib';
        };
        modules = [
          ./modules
          ./hosts
        ];
      };
  in {
    nixosConfigurations = {
      fazziPC = nixosCommonSystem {
        hostName = "fazziPC";
        user = "faaris";
      };
      fazziGO = nixosCommonSystem {
        hostName = "fazziGO";
        user = "faaris";
      };
      kunzozPC = nixosCommonSystem {
        hostName = "kunzozPC";
        user = "kunzoz";
      };
    };
  };
}
