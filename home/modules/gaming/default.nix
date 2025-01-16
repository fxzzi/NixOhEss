{
  config,
  lib,
  pkgs,
  ...
}: let
  heroic = pkgs.symlinkJoin {
    name = "heroic-wrapped";
    paths = [pkgs.heroic];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/heroic --add-flags "--ozone-platform=x11"
    '';
  };
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
          # See: https://github.com/ValveSoftware/gamescope/issues/1622#issuecomment-2508182530
          NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
        }))
        osu-lazer-bin
        lutris
        cemu
      ]
      ++ [heroic];
  };
  imports = [./mangohud];
}
