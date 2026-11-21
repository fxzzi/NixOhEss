{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.mpd.discord-rpc;
  pkg = pkgs.mpd-discord-rpc;
in
{
  options.cfg.services.mpd.discord-rpc.enable = mkEnableOption "discord-rpc";
  config = mkIf cfg.enable {
    hj = {

      xdg.config.files."discord-rpc/config.toml" = {
        generator = (pkgs.formats.toml { }).generate "config.toml";
        value = {
          hosts = [ "localhost:6600" ];
          format = {
            details = "$title";
            state = "$artist";
            timestamp = "both";
            large_image = "notes";
            large_text = "$album";
            small_image = "";
            small_text = "";
            display_type = "state";
          };
        };
      };

      systemd.services.mpd-discord-rpc = {
        description = "Discord Rich Presence for MPD";
        documentation = [ "https://github.com/JakeStanger/mpd-discord-rpc" ];
        wantedBy = [ "mpd.service" ];
        requires = [ "mpd.service" ];
        # make sure it starts and stops with mpd
        partOf = [ "mpd.service" ];
        serviceConfig = {
          Restart = "always";
          # mpd-discord-rpc likes to get stuck sometimes
          # restart it every x minutes to work around it
          RuntimeMaxSec = "10m";
          ExecStart = getExe pkg;
        };
        restartTriggers = [
          config.hj.xdg.config.files."discord-rpc/config.toml".source
          pkg
        ];
      };
    };
  };
}
