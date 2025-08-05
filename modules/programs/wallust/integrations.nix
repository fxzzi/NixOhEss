{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkForce;
  cfg = config.cfg.programs.wallust;
in {
  config = mkIf cfg.enable {
    programs.foot.settings.main.include = mkForce "~/.cache/wallust/colors_foot.ini";
    hj = {
      xdg.config.files."hypr/hyprland.conf" = {
        value.source = [
          "~/.cache/wallust/colors_hyprland.conf"
        ];
      };
      xdg.config.files."fuzzel/fuzzel.ini" = {
        value = {
          main.include = "~/.cache/wallust/colors_fuzzel.ini";
        };
      };
    };
  };
}
