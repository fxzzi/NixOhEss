{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.cfg.gui.wallust.enable {
    wayland.windowManager.hyprland.settings.source = lib.mkIf config.cfg.gui.hypr.hyprland.enable [
      "~/.cache/wallust/colors_hyprland.conf"
    ];
    programs.foot.settings.main.include =
      lib.mkIf config.cfg.gui.foot.enable
      "~/.cache/wallust/colors_foot.ini";
    programs.fuzzel.settings.main.include =
      lib.mkIf config.cfg.gui.foot.enable
      "~/.cache/wallust/colors_fuzzel.ini";
  };
}
