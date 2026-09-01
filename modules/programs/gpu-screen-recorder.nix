{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.programs.gpu-screen-recorder;
in
{
  options.cfg.programs.gpu-screen-recorder.enable = mkEnableOption "gpu-screen-recorder";
  config = mkIf cfg.enable {
    programs.gpu-screen-recorder = {
      enable = true;
      ui.enable = true;
    };
    hj.systemd.services.gpu-screen-recorder = {
      description = "A ShadowPlay-like screen recorder for Linux";
      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = getExe config.programs.gpu-screen-recorder.ui.package;
      };
      restartTriggers = [
        config.programs.gpu-screen-recorder.ui.package
      ];
    };
  };
}
