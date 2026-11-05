{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.mate-polkit;
in
{
  options.cfg.services.mate-polkit.enable = mkEnableOption "mate-polkit";
  config = mkIf cfg.enable {
    security.polkit.enable = true;
    hj.systemd.services.mate-polkit = self.lib.mkGraphicalService {
      description = "Mate Polkit";
      exec = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
      extra.restartTriggers = [
        pkgs.mate-polkit
      ];

    };
  };
}
