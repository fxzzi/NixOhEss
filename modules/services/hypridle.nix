{
  config,
  pkgs,
  lib,
  xLib,
  ...
}: let
  # toHyprlang broken for now, use toHyprconf instead
  inherit (xLib.generators) toHyprconf;
in {
  options.cfg.gui.hypr.hypridle = {
    enable = lib.mkEnableOption "hypridle";
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
    hj = {
      packages = [pkgs.hypridle];
      files = {
        ".config/hypr/hypridle.conf".text = toHyprconf {
          attrs = {
            general = {
              lock_cmd = "${lib.getExe' pkgs.procps "pidof"} hyprlock || ${lib.getExe pkgs.hyprlock}";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
              ignore_dbus_inhibit = false;
              ignore_systemd_inhibit = false;
            };
            listener =
              lib.optionals (config.cfg.gui.hypr.hypridle.dpmsTimeout != 0) [
                {
                  timeout = config.cfg.gui.hypr.hypridle.dpmsTimeout;
                  on-timeout = "hyprctl dispatch dpms off";
                  on-resume = "hyprctl dispatch dpms on";
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
    };
    systemd.user.services.hypridle = {
      enable = true;
      description = "hypridle service";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY"; # Only start if WAYLAND_DISPLAY env var is set
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${lib.getExe pkgs.hypridle}";
      };
    };
  };
}
