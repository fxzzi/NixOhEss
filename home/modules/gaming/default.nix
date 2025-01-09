{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  nixpkgs-olympus = inputs.nixpkgs-olympus.legacyPackages.${pkgs.system};
  nixpkgs-sgdboop = inputs.nixpkgs-sgdboop.legacyPackages.${pkgs.system};

  wine-ge-wrapped = pkgs.runCommand "wine-ge-wrapped" {
    buildInputs = [ inputs.nix-gaming.packages.${pkgs.system}.wine-ge ];
  } ''
    mkdir -p "$out/bin"
    for f in ${inputs.nix-gaming.packages.${pkgs.system}.wine-ge}/bin/*; do
      ln -s "$f" "$out/bin/$(basename "$f")-ge"
    done
  '';

  wine-tkg-wrapped = pkgs.runCommand "wine-tkg-wrapped" {
    buildInputs = [ inputs.nix-gaming.packages.${pkgs.system}.wine-tkg ];
  } ''
    mkdir -p "$out/bin"
    for f in ${inputs.nix-gaming.packages.${pkgs.system}.wine-tkg}/bin/*; do
      ln -s "$f" "$out/bin/$(basename "$f")-tkg"
    done
  '';

in {
  options.gaming.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable gaming packages and configuration.";
  };

  config = lib.mkIf config.gaming.enable {
    home.packages = with pkgs;
      [
        (prismlauncher.override {
          jdks = [
            temurin-jre-bin-8
            temurin-jre-bin-17
            temurin-jre-bin-21
          ];
          gamemodeSupport = true;
        })
        (gamescope.overrideAttrs (_: {
          NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
        }))
        osu-lazer-bin
        lutris
        heroic
        cemu
				wine-staging
      ]
      ++ [
        nixpkgs-olympus.olympus
        nixpkgs-sgdboop.sgdboop
        # wine-ge-wrapped
        # wine-tkg-wrapped
      ];
  };
  imports = [./mangohud];
}
