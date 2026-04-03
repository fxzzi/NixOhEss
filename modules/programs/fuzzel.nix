{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.fuzzel;
in {
  options.cfg.programs.fuzzel.enable = mkEnableOption "fuzzel";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        (pkgs.fuzzel.override {svgBackend = "librsvg";})
      ];
      xdg.config.files."fuzzel/fuzzel.ini" = {
        generator = lib.generators.toINI {};
        value = {
          main = {
            font = "monospace:size=17";
            line-height = "28";
            prompt = "' '";
            layer = "overlay";
            lines = "12";
            icon-theme = "Papirus-Dark";
            horizontal-pad = "8";
            vertical-pad = "8";
            inner-pad = "6";
            filter-desktop = true;
            terminal = "foot";
            fields = "name,exec";
            placeholder = "Search...";
            match-mode = "exact";
            dpi-aware = false;
            # always sort alphabetically
            cache = "/dev/null";
          };
          border = {
            radius = "0";
            width = "2";
          };
        };
      };
    };
  };
}
