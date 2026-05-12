{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.mpd.notification;
in {
  options.cfg.services.mpd.notification.enable = mkEnableOption "mpd-notification";
  config = mkIf cfg.enable {
    hj = {
      xdg.config.files."mpd-notification.conf" = {
        generator = lib.generators.toKeyValue {};
        value = {
          music-dir = "${config.hj.directory}/Music";
          scale = 96;
          timeout = 3;
          text-topic = "Now Playing";
          text-play = " %t\\n %a";
          # these below notifs are hidden by dunst
          text-pause = "dontshow";
          text-stop = "dontshow";
        };
      };
    };
    hj.systemd.services.mpd-notification = {
      description = "Notify about tracks played by mpd ";
      documentation = ["https://github.com/eworm-de/mpd-notification"];
      wantedBy = ["mpd.service"];
      requires = ["mpd.service"];
      # make sure it starts and stops with mpd
      partOf = ["mpd.service"];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${getExe pkgs.mpd-notification}";
      };
      restartTriggers = [
        config.hj.xdg.config.files."mpd-notification.conf".source
        pkgs.mpd-notification
      ];
    };
  };
}
