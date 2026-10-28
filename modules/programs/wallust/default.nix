{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.wallust;
in
{
  options.cfg.programs.wallust.enable = mkEnableOption "wallust";
  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        wallust
      ];
      xdg.config.files = {
        "wallust/wallust.toml" = {
          generator = (pkgs.formats.toml { }).generate "wallust.toml";
          value = {
            check_contrast = true;
            backend = "fastresize";
            color_space = "lch";
            templates = {
              fuzzel = {
                template = ./templates/colors_fuzzel.ini;
                target = "~/.cache/wallust/colors_fuzzel.ini";
              };
              hyprland = {
                template = ./templates/colors_hyprland.lua;
                target = "~/.config/hypr/colors_hyprland.lua";
              };
              ags = {
                template = ./templates/colors_ags.css;
                target = "~/.config/ags/colors_ags.css";
              };
              foot = {
                template = ./templates/colors_foot.ini;
                target = "~/.cache/wallust/colors_foot.ini";
              };
              wleave = {
                template = ./templates/colors_wleave.css;
                target = "~/.config/wleave/colors_wleave.css";
              };
              dunst = {
                template = ./templates/99-wallust.conf;
                target = "~/.config/dunst/dunstrc.d/99-wallust.conf";
              };
              # contains one hex of the accent colour of current theme.
              # currently used in screenshot script for the border colour.
              # may be used for other things later.
              accent = {
                template = "accent.txt";
                target = "~/.cache/wallust/accent.txt";
              };
            };
            hooks = {
              dunst = "dunstctl reload";
            };
          };
        };
      };
    };
  };
}
