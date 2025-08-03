{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkForce;
  toINI = lib.generators.toINI {};
  cfg = config.cfg.programs.wallust;
in {
  config = mkIf cfg.enable {
    programs.foot.settings.main.include = mkForce "~/.cache/wallust/colors_foot.ini";
    programs.hyprland.settings.source = [
      "~/.cache/wallust/colors_hyprland.conf"
    ];
    hj = {
      files = {
        ".config/fuzzel/fuzzel.ini".text = toINI {
          main.include = "~/.cache/wallust/colors_fuzzel.ini";
        };
      };
    };
  };
}
