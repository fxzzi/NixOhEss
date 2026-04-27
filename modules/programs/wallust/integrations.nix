{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkBefore;
  cfg = config.cfg.programs.wallust;
in {
  config = mkIf cfg.enable {
    hj = {
      xdg.config.files = {
        "hypr/hyprland.lua" = {
          text = mkBefore ''
            require("colors_hyprland")
          '';
        };
        "fuzzel/fuzzel.ini" = {
          value = {
            main.include = "~/.cache/wallust/colors_fuzzel.ini";
          };
        };
        "foot/foot.ini" = {
          value = {
            main.include = "~/.cache/wallust/colors_foot.ini";
          };
        };
      };
    };
  };
}
