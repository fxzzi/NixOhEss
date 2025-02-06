{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.gui.wallust.enable {
    wayland.windowManager.hyprland.settings.source = lib.mkIf config.gui.hypr.hyprland.enable [
      "~/.cache/wallust/colors_hyprland.conf"
    ];
    programs.foot.settings.main.include =
      lib.mkIf config.gui.foot.enable
      "~/.cache/wallust/colors_foot.ini";
    programs.fuzzel.settings.main.include =
      lib.mkIf config.gui.foot.enable
      "~/.cache/wallust/colors_fuzzel.ini";
  };
}
