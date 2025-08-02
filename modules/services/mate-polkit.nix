{
  lib,
  config,
  pkgs,
  ... 
}: {
  options.cfg.services.mate-polkit.enable = lib.mkEnableOption "mate-polkit";
  config = lib.mkIf config.cfg.services.mate-polkit.enable {
    systemd.user.services.mate-polkit = {
      enable = true;
      description = "Mate Polkit";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY"; # Only start if WAYLAND_DISPLAY env var is set
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}