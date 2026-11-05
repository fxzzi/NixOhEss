{
  config,
  lib,
  self,
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
    hj.systemd.services.gpu-screen-recorder = self.lib.mkGraphicalService {
      description = "A ShadowPlay-like screen recorder for Linux";
      exec = getExe config.programs.gpu-screen-recorder.ui.package;
      extra.restartTriggers = [
        config.programs.gpu-screen-recorder.ui.package
      ];
    };
  };
}
