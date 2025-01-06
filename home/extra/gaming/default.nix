{ pkgs, inputs, ... }:
let
  nixpkgs-olympus = inputs.nixpkgs-olympus.legacyPackages.${pkgs.system};
  nixpkgs-sgdboop = inputs.nixpkgs-sgdboop.legacyPackages.${pkgs.system};
in
{
  home.packages = [
    nixpkgs-olympus.olympus
    nixpkgs-sgdboop.sgdboop
    (pkgs.prismlauncher.override {
      # use temurin, they're better
      jdks = [
        pkgs.temurin-jre-bin-8
        pkgs.temurin-jre-bin-17
        pkgs.temurin-jre-bin-21
      ];
    })
    (pkgs.osu-lazer-bin.override {
      nativeWayland = true;
    })
    pkgs.lutris
    pkgs.gamescope
    pkgs.heroic
    pkgs.cemu
    pkgs.wine-staging
  ];
  imports = [ ./mangohud ];
}
