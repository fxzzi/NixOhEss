{
  lib,
  config,
  inputs,
  pkgs,
  osConfig,
  ...
}: let
  pkg =
    if osConfig.wayland.hyprland.useGit
    then inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}
    else pkgs;
in {
  options.gui.hypr.hyprpaper.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables hyprpaper and its configs.";
  };
  config = lib.mkIf config.gui.hypr.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      package = pkg.hyprpaper;
      settings = {
        ipc = 1;
        splash = 0;
      };
    };
  };
}
