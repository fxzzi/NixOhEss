{
  pkgs,
  lib,
  config,
  ...
}: {
  options.gui.fuzzel.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables fuzzel and its configs.";
  };
  config = lib.mkIf config.gui.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      package = pkgs.fuzzel.override {svgBackend = "librsvg";};
      settings = {
        main = {
          font = "SpaceMono Nerd Font:size=17";
          line-height = "30";
          prompt = "' '";
          layer = "overlay";
          lines = "10";
          icon-theme = "Papirus-Dark";
          horizontal-pad = "10";
          vertical-pad = "10";
          inner-pad = "6";
          filter-desktop = true;
          image-size-ratio = "0.5";
          terminal = "foot -e";
          fields = "name,exec";
          placeholder = "Search...";
          sort-result = "false";
          match-mode = "exact";
          dpi-aware = false;
          include = lib.mkIf config.gui.wallust.enable "~/.cache/wallust/colors_fuzzel.ini";
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
