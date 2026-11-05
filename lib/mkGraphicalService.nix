# Builds a systemd user service which is tied to the graphical session and
# only runs under Wayland. Anything service-specific (restartTriggers, path,
# environment, extra serviceConfig, ...) goes in `extra`, which is merged
# recursively over the defaults.
lib:
{
  description,
  exec,
  extra ? { },
}:
lib.recursiveUpdate {
  inherit description;
  after = [ "graphical-session.target" ];
  wantedBy = [ "graphical-session.target" ];
  partOf = [ "graphical-session.target" ];
  unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
  serviceConfig = {
    Type = "simple";
    Restart = "always";
    ExecStart = exec;
  };
} extra
