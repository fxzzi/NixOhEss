{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.cfg.programs.wallust;
in {
  config = mkIf cfg.enable {
    hj = {
      xdg.config.files = {
        "hypr/hyprland.conf" = {
          value.source = [
            "~/.cache/wallust/colors_hyprland.conf"
          ];
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
