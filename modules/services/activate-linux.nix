{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.activate-linux;
in {
  options.cfg.services.activate-linux.enable = mkEnableOption "activate-linux";
  config = mkIf cfg.enable {
    hj.systemd.services.activate-linux = {
      description = "Activate Linux watermark";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${getExe pkgs.activate-linux}";
      };
    };
  };
}
