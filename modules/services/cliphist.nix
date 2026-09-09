{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe
    getExe'
    ;
  cfg = config.cfg.services.cliphist;
in
{
  options.cfg.services.cliphist.enable = mkEnableOption "cliphist";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.cliphist
        pkgs.wl-clipboard
      ];
      systemd.services = {
        cliphist = {
          description = "Wayland clipboard manager with support for multimedia";
          after = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          unitConfig = {
            ConditionEnvironment = "WAYLAND_DISPLAY";
          };
          serviceConfig = {
            Type = "simple";
            Restart = "always";
            ExecStart = "${getExe' pkgs.wl-clipboard "wl-paste"} --watch ${getExe pkgs.cliphist} -max-items 24 -min-store-length 2 -preview-width 75 store";
          };
          restartTriggers = [
            pkgs.cliphist
            pkgs.wl-clipboard
          ];
        };
        wl-clip-persist = {
          description = "Keep Wayland clipboard even after programs close";
          after = [
            "graphical-session.target"
            "cliphist.service"
          ];
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          unitConfig = {
            ConditionEnvironment = "WAYLAND_DISPLAY";
          };
          serviceConfig = {
            Type = "simple";
            Restart = "always";
            ExecStart = "${getExe pkgs.wl-clip-persist} --clipboard regular";
          };
          restartTriggers = [
            pkgs.wl-clip-persist
          ];
        };
      };
    };
  };
}
