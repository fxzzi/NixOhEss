{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.hyprsunset;
in {
  options.cfg.services.hyprsunset.enable = mkEnableOption "hyprsunset";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.hyprsunset
      ];
    };
    systemd.user.services.hyprsunset = {
      enable = true;
      description = "Hyprsunset blue light filter";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY"; # Only start if WAYLAND_DISPLAY env var is set
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        # --identity starts hyprsunset without changing temperature
        ExecStart = "${getExe pkgs.hyprsunset} --identity";
      };
    };
  };
}
