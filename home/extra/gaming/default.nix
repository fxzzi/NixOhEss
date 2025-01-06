{ pkgs, inputs, ... }:
let
  nixpkgs-olympus = inputs.nixpkgs-olympus.legacyPackages.${pkgs.system};
  nixpkgs-sgdboop = inputs.nixpkgs-sgdboop.legacyPackages.${pkgs.system};
in
{
  home.packages =
    with pkgs;
    [
      (prismlauncher.override {
        # use temurin, they're better
        jdks = [
          temurin-jre-bin-8
          temurin-jre-bin-17
          temurin-jre-bin-21
        ];
      })
      osu-lazer-bin
      lutris
      gamescope
      heroic
      cemu
      wine-staging
    ]
    ++ [
      nixpkgs-olympus.olympus
      nixpkgs-sgdboop.sgdboop
    ];
  imports = [ ./mangohud ];
}
