{
  config,
  pkgs,
  lib,
  self,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types optionals getExe;
  cfg = config.cfg.services.hypridle;
  dpms = state: "hyprctl dispatch 'hl.dsp.dpms({ action = \"${state}\" })'";
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
        generator = self.lib.generators.toHyprconf;
        value = {
          attrs = {
            general = {
              lock_cmd = "pidof hyprlock || hyprlock";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = dpms "on";
            };
            listener =
              optionals (cfg.dpmsTimeout != 0) [
                {
                  timeout = cfg.dpmsTimeout;
                  on-timeout = dpms "off";
                  on-resume = dpms "on";
                }
              ]
              ++ optionals (cfg.lockTimeout != 0) [
                {
                  timeout = cfg.lockTimeout;
                  on-timeout = "loginctl lock-session";
                }
                {
                  timeout = 60;
                  # dpms off screen if hyprlock is running
                  on-timeout = "pidof hyprlock && ${dpms "off"}";
                  on-resume = dpms "on";
                  # no matter what, dimming screen on lockscreen shouldn't be a problem
                  ignore_inhibit = true;
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
    hj.systemd.services.hypridle = {
      description = "Hypridle idle management";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = getExe pkgs.hypridle;
      };
      path = [
        config.programs.hyprland.package # for hyprctl
        pkgs.procps # for pidof
        pkgs.hyprlock
      ];
      restartTriggers = [
        config.hj.xdg.config.files."hypr/hypridle.conf".source
        pkgs.hypridle
      ];
    };
  };
}
