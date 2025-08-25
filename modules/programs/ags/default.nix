{
  lib,
  config,
  pkgs,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) callPackage;
  cfg = config.cfg.programs.ags;
  pkg = callPackage "${npins.rags}/nix/package.nix" {
    buildTypes = false;
    extraPackages = [
      pkgs.libgtop
    ];
  };
in {
  options.cfg.programs.ags.enable = mkEnableOption "ags";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkg
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
