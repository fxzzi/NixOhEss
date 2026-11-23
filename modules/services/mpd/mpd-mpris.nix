{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.mpd.mpris;
  pkg = pkgs.mpd-mpris;
in
{
  options.cfg.services.mpd.mpris.enable = mkEnableOption "mpd-mpris";
  config = mkIf cfg.enable {
    hj.systemd.services.mpd-mpris = {
      description = "MPRIS bridge for MPD";
      documentation = [ "https://github.com/natsukagami/mpd-mpris" ];
      wantedBy = [ "mpd.service" ];
      requires = [ "mpd.service" ];
      after = [ "mpd.service" ];
      # make sure it starts and stops with mpd
      partOf = [ "mpd.service" ];
      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${getExe pkg} -no-instance";
      };
      restartTriggers = [ pkg ];
    };
  };
}
