{ pkgs, inputs, ... }:
let
  nixpkgs-olympus = inputs.nixpkgs-olympus.legacyPackages.${pkgs.system};
in
{
  home.packages = [
    nixpkgs-olympus.olympus
    (pkgs.prismlauncher.override {
      # use temurin, they're better
      jdks = [
        pkgs.temurin-jre-bin-8
        pkgs.temurin-jre-bin-17
        pkgs.temurin-jre-bin-21
      ];
    })
    pkgs.lutris
    pkgs.gamemode
    pkgs.gamescope
    pkgs.heroic
    pkgs.osu-lazer-bin
    pkgs.cemu
  ];
  imports = [ ./mangohud ];
}
