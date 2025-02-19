{
  config,
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}: let
  pkg =
    if osConfig.wayland.hyprland.useGit
    then inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}
    else pkgs;
in {
  options.gui.hypr.hypridle.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables hypridle and its configs.";
  };
  options.gui.hypr.hypridle.suspendTimeout = lib.mkOption {
    type = lib.types.int;
    default = 360;
    description = "Sets the suspend timeout for hypridle.";
  };
  config = lib.mkIf config.gui.hypr.hypridle.enable {
    services.hypridle = {
      enable = true;
      package = pkg.hypridle;
      settings = {
        general = {
          lock_cmd = "${lib.getExe config.programs.hyprlock.package}";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "${lib.getExe' osConfig.programs.hyprland.package "hyprctl"} dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "${lib.getExe' osConfig.programs.hyprland.package "hyprctl"} dispatch dpms off";
            on-resume = "${lib.getExe' osConfig.programs.hyprland.package "hyprctl"} dispatch dpms on";
          }
          {
            timeout = 330;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = config.gui.hypr.hypridle.suspendTimeout;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
