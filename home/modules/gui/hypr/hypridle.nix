{
  config,
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}: let
  pkg =
    if osConfig.cfg.wayland.hyprland.useGit
    then inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}
    else pkgs;
in {
  options.cfg.gui.hypr.hypridle = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables hypridle and its configs.";
    };
    dpmsTimeout = lib.mkOption {
      type = lib.types.int;
      default = 300;
      description = ''
        Sets the time in seconds for your screen to turn off when idle.
        If you set this to 0, the screen won't turn off when idle.'';
    };
    lockTimeout = lib.mkOption {
      type = lib.types.int;
      default = 330;
      description = ''
        Sets the time in seconds for the PC to automatically lock when idle.
        If you set this to 0, the PC won't lock when idle.'';
    };
    suspendTimeout = lib.mkOption {
      type = lib.types.int;
      default = 360;
      description = ''
        Sets the time in seconds for the PC to automatically sleep when idle.
        If you set this to 0, the PC won't sleep automatically when idle.'';
    };
  };
  config = lib.mkIf config.cfg.gui.hypr.hypridle.enable {
    services.hypridle = {
      enable = true;
      package = pkg.hypridle;
      settings = {
        general = {
          lock_cmd = "${lib.getExe config.programs.hyprlock.package}";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "${lib.getExe' osConfig.programs.hyprland.package "hyprctl"} dispatch dpms on";
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false;
        };
        listener =
          lib.optionals (config.cfg.gui.hypr.hypridle.dpmsTimeout != 0) [
            {
              timeout = config.cfg.gui.hypr.hypridle.dpmsTimeout;
              on-timeout = "${lib.getExe' osConfig.programs.hyprland.package "hyprctl"} dispatch dpms off";
              on-resume = "${lib.getExe' osConfig.programs.hyprland.package "hyprctl"} dispatch dpms on";
            }
          ]
          ++ lib.optionals (config.cfg.gui.hypr.hypridle.lockTimeout != 0) [
            {
              timeout = config.cfg.gui.hypr.hypridle.lockTimeout;
              on-timeout = "loginctl lock-session";
            }
          ]
          ++ lib.optionals (config.cfg.gui.hypr.hypridle.suspendTimeout != 0) [
            {
              timeout = config.cfg.gui.hypr.hypridle.suspendTimeout;
              on-timeout = "systemctl suspend";
            }
          ];
      };
    };
  };
}
