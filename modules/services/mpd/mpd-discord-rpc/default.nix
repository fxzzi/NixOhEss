{
  lib,
  config,
  pkgs,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
  fmt = cfg: tomlFormat.generate "config.toml" cfg;
in {
  options.cfg.music.mpd.discord-rpc.enable = lib.mkEnableOption "discord-rpc";
  config = lib.mkIf config.cfg.music.mpd.discord-rpc.enable {
    hj = {
      files = {
        ".config/discord-rpc/config.toml".source = fmt {
          hosts = ["localhost:6600"];
          format = {
            details = "$title";
            state = "$artist";
            timestamp = "elapsed";
            large_image = "notes";
            small_image = "";
            large_text = "$album";
            small_text = "";
          };
        };
      };
    };
    systemd.user.services.mpd-discord-rpc = {
      enable = true;
      description = "Discord Rich Presence for MPD";
      documentation = ["https://github.com/JakeStanger/mpd-discord-rpc"];
      wantedBy = [
        "mpd.service"
      ];
      requires = [
        "mpd.service"
      ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${lib.getExe pkgs.mpd-discord-rpc}";
      };
    };
  };
}
