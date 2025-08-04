{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.ags;
in {
  options.cfg.programs.ags.enable = mkEnableOption "ags";
  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (_: prev: {
        ags_1 = prev.ags_1.overrideAttrs (old: {
          # this package isn't included in the buildInputs by default for some reason.
          buildInputs = old.buildInputs ++ [prev.libdbusmenu-gtk3];
        });
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
