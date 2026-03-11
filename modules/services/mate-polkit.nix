{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.mate-polkit;
in {
  options.cfg.services.mate-polkit.enable = mkEnableOption "mate-polkit";
  config = mkIf cfg.enable {
    security.polkit.enable = true;
    hj.systemd.services.mate-polkit = {
      description = "Mate Polkit";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
