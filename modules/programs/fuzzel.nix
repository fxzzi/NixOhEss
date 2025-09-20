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
        pkgs.fuzzel
      ];
      xdg.config.files."fuzzel/fuzzel.ini" = {
        generator = lib.generators.toINI {};
        value = {
          main = {
            font = "monospace:size=17";
            line-height = "30";
            prompt = "' '";
            layer = "overlay";
            lines = "10";
            icon-theme = "Papirus-Dark";
            horizontal-pad = "10";
            vertical-pad = "10";
            inner-pad = "6";
            filter-desktop = true;
            terminal = "foot";
            fields = "name,exec";
            placeholder = "Search...";
            match-mode = "exact";
            dpi-aware = false;
          };
          border = {
            radius = "6";
            width = "2";
          };
          key-bindings = {
            prev-with-wrap = "Up";
            next-with-wrap = "Down";
            prev = "None";
            next = "None";
          };
        };
      };
    };
  };
}
