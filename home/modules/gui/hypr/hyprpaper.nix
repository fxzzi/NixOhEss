{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  options.gui.hypr.hyprpaper.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables hyprpaper and its configs.";
  };
  config = lib.mkIf config.gui.hypr.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      package = inputs.hyprpaper.packages.${pkgs.system}.default;
      settings = {
        ipc = 1;
        splash = 0;
      };
    };
  };
}
