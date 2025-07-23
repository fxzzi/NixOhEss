{
  description = "fazzi's nixos + hjem conf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        smfh.follows = ""; # we use smfh from nixpkgs
      };
    };
    aquamarine = {
      url = "github:hyprwm/aquamarine";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };

    hyprcursor = {
      url = "github:hyprwm/hyprcursor";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprlang.follows = "hyprlang";
      };
    };

    hyprgraphics = {
      url = "github:hyprwm/hyprgraphics";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprutils.follows = "hyprutils";
      };
    };

    hyprland-protocols = {
      url = "github:hyprwm/hyprland-protocols";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprland-qtutils = {
      url = "github:hyprwm/hyprland-qtutils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprlang.follows = "hyprlang";
      };
    };

    hyprlang = {
      url = "github:hyprwm/hyprlang";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprutils.follows = "hyprutils";
      };
    };

    hyprutils = {
      url = "github:hyprwm/hyprutils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprwayland-scanner = {
      url = "github:hyprwm/hyprwayland-scanner";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprland-protocols.follows = "hyprland-protocols";
        hyprlang.follows = "hyprlang";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        aquamarine.follows = "aquamarine";
        hyprcursor.follows = "hyprcursor";
        hyprgraphics.follows = "hyprgraphics";
        hyprland-protocols.follows = "hyprland-protocols";
        hyprland-qtutils.follows = "hyprland-qtutils";
        hyprlang.follows = "hyprlang";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
        xdph.follows = "xdph";
      };
    };
    ags = {
      url = "github:aylur/ags/v1";
      # url = "github:NotAShelf/rags"; # raf's agsv1 fork
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    nvuv = {
      url = "gitlab:fazzi/nvuv";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = ""; # ew, home-manager
        darwin.follows = ""; # ew, apple
      };
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    creamlinux = {
      # FIXME: pin to older release until i have the time to update the flake
      url = "github:Novattz/creamlinux-installer/17ad517a459f1a41a40bef2642ee952859147ab5";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
  };

  outputs = inputs: let
    npins = import ./npins;
    xLib = import ./lib inputs.nixpkgs.lib;

    nixosCommonSystem = {
      hostName,
      user,
    }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            npins
            hostName
            user
            xLib
            ;
        };
        modules = [
          ./modules
          ./hosts/${hostName}
        ];
      };

    # adding a host? Add a hostname and username here
    # then, have a gander at ./hosts
    hosts = {
      fazziPC = {user = "faaris";};
      fazziGO = {user = "faaris";};
      kunzozPC = {user = "kunzoz";};
    };
  in {
    nixosConfigurations =
      builtins.mapAttrs (
        hostName: config:
          nixosCommonSystem (config // {inherit hostName;})
      )
      hosts;
  };
  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
