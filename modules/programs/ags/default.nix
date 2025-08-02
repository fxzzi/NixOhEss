{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.cfg.programs.ags.enable = lib.mkEnableOption "ags";
  config = lib.mkIf config.cfg.programs.ags.enable {
    hj = {
      packages = [
        inputs.ags.packages.${pkgs.system}.default
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
