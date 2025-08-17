{
  lib,
  config,
  pkgs,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.ags;
in {
  options.cfg.programs.ags.enable = mkEnableOption "ags";
  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: _: {
        ags_1 = final.callPackage "${npins.rags}/nix/package.nix" {
          buildTypes = false;
          extraPackages = [
            final.libgtop
          ];
        };
      })
    ];
    hj = {
      packages = [
        pkgs.ags_1
      ];
      xdg.config.files = {
        "ags/icons".source = ./ags/icons;
        "ags/modules".source = ./ags/modules;
        "ags/config.js".source = ./ags/config.js;
        "ags/style.css".source = ./ags/style.css;
      };
    };
    services.upower.enable = config.cfg.services.watt.enable; # enable battery module if watt is in use, its a good indicator of whether we're on a laptop.
  };
}
