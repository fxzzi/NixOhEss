{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.fuzzel;

  terminal =
    if config.cfg.programs.uwsm.enable
    then "xdg-terminal-exec"
    else "foot -e";
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
            # image-size-ratio = "0.5";
            inherit terminal;
            fields = "name,exec";
            placeholder = "Search...";
            match-mode = "exact";
            dpi-aware = false;
            launch-prefix =
              if config.cfg.programs.uwsm.enable
              then "app2unit --fuzzel-compat --"
              else null;
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