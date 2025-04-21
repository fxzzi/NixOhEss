{
  description = "fazzi's nixos + hm conf";

  inputs = {
    # shallow clone these so its faster to fetch.
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    nixpkgs-olympus.url = "git+https://github.com/Petingoso/nixpkgs?shallow=1&ref=olympus";
    nixpkgs-sgdboop.url = "git+https://github.com/Saturn745/nixpkgs?shallow=1&ref=sgdboop-init";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # reduce duplicate packages by making all hypr*
    # inputs follow the ones from Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprgraphics.follows = "hyprland/hyprgraphics";
      };
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprgraphics.follows = "hyprland/hyprgraphics";
      };
    };
    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprutils.follows = "hyprland/hyprutils";
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };
    ags = {
      url = "github:Aylur/ags/v1"; # still on v1 lmfao
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
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
        darwin.follows = ""; # don't need darwin deps
      };
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    creamlinux = {
      url = "github:Novattz/creamlinux-installer";
      inputs.nixpkgs.follows = "nixpkgs";
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

    machines = [
      {
        hostName = "fazziPC";
        user = "faaris";
      }
      {
        hostName = "fazziGO";
        user = "faaris";
      }
      {
        hostName = "kunzozPC";
        user = "kunzoz";
      }
    ];

    nixosCommonSystem = {
      hostName,
      user,
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs npins hostName user;
        };
        modules = [./hosts];
      };
  in {
    nixosConfigurations = builtins.listToAttrs (
      map (machine: {
        name = machine.hostName;
        value = nixosCommonSystem machine;
      })
      machines
    );
  };
}
