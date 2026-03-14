{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionalAttrs;
  cfg = config.cfg.programs.wallust;
in {
  options.cfg.programs.wallust.enable = mkEnableOption "wallust";
  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        wallust
      ];
      xdg.config.files = {
        "wallust/templates".source = ./templates;
        "wallust/wallust.toml" = {
          generator = (pkgs.formats.toml {}).generate "wallust.toml";
          value = {
            check_contrast = true;
            backend = "resized";
            color_space = "lch";
            templates = {
              fuzzel = optionalAttrs config.cfg.programs.fuzzel.enable {
                template = "colors_fuzzel.ini";
                target = "~/.cache/wallust/colors_fuzzel.ini";
              };
              hyprland = optionalAttrs config.cfg.programs.hyprland.enable {
                template = "colors_hyprland.conf";
                target = "~/.cache/wallust/colors_hyprland.conf";
              };
              ags = optionalAttrs config.cfg.services.ags.enable {
                template = "colors_ags.css";
                target = "~/.config/ags/colors_ags.css";
              };
              foot = optionalAttrs config.cfg.programs.foot.enable {
                template = "colors_foot.ini";
                target = "~/.cache/wallust/colors_foot.ini";
              };
              wleave = optionalAttrs config.cfg.programs.wleave.enable {
                template = "colors_wleave.css";
                target = "~/.config/wleave/colors_wleave.css";
              };
              dunst = optionalAttrs config.cfg.services.dunst.enable {
                template = "99-wallust.conf";
                target = "~/.config/dunst/dunstrc.d/99-wallust.conf";
              };
            };
          };
        };
      };
    };
  };
}
