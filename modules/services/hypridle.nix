{
  config,
  pkgs,
  lib,
  xLib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types optionals getExe getExe';
  cfg = config.cfg.services.hypridle;
in {
  options.cfg.services.hypridle = {
    enable = mkEnableOption "hypridle";
    dpmsTimeout = mkOption {
      type = types.int;
      default = 300;
      description = ''
        Sets the time in seconds for your screen to turn off when idle.
        If you set this to 0, the screen won't turn off when idle.'';
    };
    lockTimeout = mkOption {
      type = types.int;
      default = 330;
      description = ''
        Sets the time in seconds for the PC to automatically lock when idle.
        If you set this to 0, the PC won't lock when idle.'';
    };
    suspendTimeout = mkOption {
      type = types.int;
      default = 360;
      description = ''
        Sets the time in seconds for the PC to automatically sleep when idle.
        If you set this to 0, the PC won't sleep automatically when idle.'';
    };
  };
  config = mkIf cfg.enable {
    hj = {
      packages = [pkgs.hypridle];
      xdg.config.files."hypr/hypridle.conf" = {
        generator = xLib.generators.toHyprconf;
        value = {
          attrs = {
            general = {
              lock_cmd = "${getExe' pkgs.procps "pidof"} hyprlock || ${getExe pkgs.hyprlock}";
              before_sleep_cmd = "${getExe' pkgs.systemd "loginctl"} lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
              ignore_dbus_inhibit = false;
              ignore_systemd_inhibit = false;
            };
            listener =
              optionals (cfg.dpmsTimeout != 0) [
                {
                  timeout = cfg.dpmsTimeout;
                  on-timeout = "hyprctl dispatch dpms off";
                  on-resume = "hyprctl dispatch dpms on";
                }
              ]
              ++ optionals (cfg.lockTimeout != 0) [
                {
                  timeout = cfg.lockTimeout;
                  on-timeout = "loginctl lock-session";
                }
              ]
              ++ optionals (cfg.suspendTimeout != 0) [
                {
                  timeout = cfg.suspendTimeout;
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
        ExecStart = "${getExe pkgs.hypridle}";
      };
    };
  };
}
