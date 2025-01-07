{ lib, config, ... }:
{
  options.gui.hypr.hyprpaper.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables hyprpaper and its configs.";
  };
  config = lib.mkIf config.gui.hypr.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = 1;
        splash = 0;
      };
    };
  };
}
