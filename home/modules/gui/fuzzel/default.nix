{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  terminal =
    if osConfig.cfg.wayland.uwsm.enable
    then "xdg-terminal-exec"
    else "foot -e";
in {
  options.cfg.gui.fuzzel.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables fuzzel and its configs.";
  };
  config = lib.mkIf config.cfg.gui.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      package = pkgs.fuzzel.override {svgBackend = "librsvg";};
      settings = {
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
          image-size-ratio = "0.5";
          inherit terminal;
          fields = "name,exec";
          placeholder = "Search...";
          match-mode = "exact";
          dpi-aware = false;
          launch-prefix = lib.mkIf osConfig.cfg.wayland.uwsm.enable "app2unit --fuzzel-compat --";
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
}
