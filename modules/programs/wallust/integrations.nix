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
    programs.hyprland.settings.source = [
      "~/.cache/wallust/colors_hyprland.conf"
    ];
    hj = {
      xdg.config.files."fuzzel/fuzzel.ini" = {
        generator = lib.generators.toINI {};
        value = {
          main.include = "~/.cache/wallust/colors_fuzzel.ini";
        };
      };
    };
  };
}