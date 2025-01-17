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
          font = "monospace:size=10";
          line-height = "18";
          prompt = "' '";
          layer = "overlay";
          lines = "10";
          icon-theme = config.gtk.iconTheme.name;
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
          dpi-aware = true;
          include = lib.mkIf config.gui.wallust.enable "~/.cache/wallust/colors_fuzzel.ini";
        };
        border = {
          radius = "0";
          width = "3";
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
