{
  lib,
  config,
  ...
}: let
  toINI = lib.generators.toINI {};
in {
  config = lib.mkIf config.cfg.gui.wallust.enable {
    programs.foot.settings.main.include = lib.mkForce "~/.cache/wallust/colors_foot.ini";
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
