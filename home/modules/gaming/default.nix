{
  config,
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}: let
  nixpkgs-olympus = inputs.nixpkgs-olympus.legacyPackages.${pkgs.system};
  nix-gaming = inputs.nix-gaming.packages.${pkgs.system};
  gpuType =
    if osConfig.gpu.nvidia.enable
    then "nvidia"
    else if osConfig.gpu.amd.enable
    then "amd"
    else "unknown"; # Fallback in case neither is enabled
in {
  options.gaming.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable gaming packages and configuration.";
  };

  config = lib.mkIf config.gaming.enable {
    home.packages = with pkgs; [
      (prismlauncher.override {
        jdks = [
          temurin-jre-bin-8
          temurin-jre-bin-17
          temurin-jre-bin-21
        ];
      })
      (gamescope_git.overrideAttrs (_: {
        # NOTE: https://github.com/ValveSoftware/gamescope/issues/1622#issuecomment-2508182530
        NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
      }))
      osu-lazer-bin
      lutris
      cemu
      heroic
      # protonup-qt
      protonplus
      nvtopPackages.${gpuType}
      nixpkgs-olympus.olympus
    ];
    xdg = {
      dataFile = {
        "lutris/runners/wine/wine-tkg" = {
          source = nix-gaming.wine-tkg;
        };
        "lutris/runners/wine/wine-ge" = {
          source = nix-gaming.wine-ge;
        };
      };
      mimeApps.defaultApplications = {
        "application/x-osu-beatmap-archive" = "osu!.desktop"; # .osz
        "application/x-osu-skin-archive" = "osu!.desktop"; # .osk
        "application/x-osu-beatmap" = "osu!.desktop"; # .osu
        "application/x-osu-storyboard" = "osu!.desktop"; # .osb
        "application/x-osu-replay" = "osu!.desktop"; # .osr
      };
    };
  };
  imports = [./mangohud];
}
