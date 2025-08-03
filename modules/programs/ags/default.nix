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
    # this package isn't included in the buildInputs by default for some reason.
    nixpkgs.overlays = [
      (_: prev: {
        ags_1 = prev.ags_1.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [prev.libdbusmenu-gtk3];
        });
      })
    ];
    hj = {
      packages = [
        pkgs.ags_1
      ];
      files = {
        ".config/ags/icons".source = ./ags/icons;
        ".config/ags/modules".source = ./ags/modules;
        ".config/ags/config.js".source = ./ags/config.js;
        ".config/ags/style.css".source = ./ags/style.css;
      };
    };
    services.upower.enable = config.cfg.services.watt.enable; # enable battery module if watt is in use, its a good indicator of whether we're on a laptop.
  };
}
