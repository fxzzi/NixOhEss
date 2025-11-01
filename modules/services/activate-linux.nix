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
    systemd.user.services.activate-linux = {
      enable = true;
      description = "Activate Linux watermark";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY"; # Only start if WAYLAND_DISPLAY env var is set
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${getExe pkgs.activate-linux}";
      };
    };
  };
}
