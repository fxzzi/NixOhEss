{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
		package = (pkgs.fuzzel.override {svgBackend = "librsvg"; });
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
        filter-desktop = "yes";
        image-size-ratio = "0.5";
        terminal = "foot -e";
        fields = "name,exec";
        placeholder = "Search...";
        sort-result = "false";
        match-mode = "exact";
        include = "~/.cache/wallust/colors_fuzzel.ini";
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
}
