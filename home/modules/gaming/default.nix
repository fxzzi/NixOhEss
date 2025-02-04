{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  nixpkgs-olympus = inputs.nixpkgs-olympus.legacyPackages.${pkgs.system};
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
        })
        (gamescope.overrideAttrs (_: {
          # NOTE: https://github.com/ValveSoftware/gamescope/issues/1622#issuecomment-2508182530
          NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
        }))
        osu-lazer-bin
        lutris
        cemu
        heroic
        protonup-qt
        nvtopPackages.nvidia
      ]
      ++ [
        nixpkgs-olympus.olympus
      ];
    xdg.mimeApps.defaultApplications = {
      "application/x-osu-beatmap-archive" = "osu!.desktop"; # .osz
      "application/x-osu-skin-archive" = "osu!.desktop"; # .osk
      "application/x-osu-beatmap" = "osu!.desktop"; # .osu
      "application/x-osu-storyboard" = "osu!.desktop"; # .osb
      "application/x-osu-replay" = "osu!.desktop"; # .osr
    };
  };
  imports = [./mangohud];
}
