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
  options.cfg.gaming.heroic.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the Heroic Games Launcher";
  };
  config = lib.mkIf config.cfg.gaming.heroic.enable {
    home.packages = [
      heroic
    ];
    xdg = {
      configFile = {
        "heroic/tools/proton/GE-Proton" = lib.mkIf config.cfg.gaming.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
      };
    };
  };
}
