{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.mpd.discord-rpc;
  pkg = pkgs.mpd-discord-rpc;
in {
  options.cfg.services.mpd.discord-rpc.enable = mkEnableOption "discord-rpc";
  config = mkIf cfg.enable {
    hj = {
      xdg.config.files."discord-rpc/config.toml" = {
        generator = (pkgs.formats.toml {}).generate "config.toml";
        value = {
          hosts = ["localhost:6600"];
          format = {
            details = "$title";
            state = "$artist";
            timestamp = "both";
            large_image = "notes";
            large_text = "$album";
            small_image = "";
            small_text = "";
            display_type = "state";
            # button1_text = "Listen on YouTube";
            # button1_link = "https://www.youtube.com/results?search_query=$artist\ -\ $title";
            # button2_text = "Album on MusicBrainz";
            # button2_url = "https://musicbrainz.org/search?query=$albumartist\ $album&type=release&method=indexed";
          };
        };
      };
    };
    hj.systemd.services.mpd-discord-rpc = {
      description = "Discord Rich Presence for MPD";
      documentation = ["https://github.com/JakeStanger/mpd-discord-rpc"];
      wantedBy = ["mpd.service"];
      requires = ["mpd.service"];
      # make sure it starts and stops with mpd
      partOf = ["mpd.service"];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = getExe pkg;
      };
      restartTriggers = [
        config.hj.xdg.config.files."discord-rpc/config.toml".source
        pkg
      ];
    };
  };
}
