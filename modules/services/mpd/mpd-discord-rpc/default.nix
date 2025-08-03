{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.mpd.discord-rpc;
  tomlFormat = pkgs.formats.toml {};
  fmt = cfg: tomlFormat.generate "config.toml" cfg;
  pkg = pkgs.mpd-discord-rpc;
in {
  options.cfg.services.mpd.discord-rpc.enable = mkEnableOption "discord-rpc";
  config = mkIf cfg.enable {
    hj = {
      xdg.config.files."discord-rpc/config.toml".source = fmt {
        hosts = ["localhost:6600"];
        format = {
          details = "$title";
          state = "$artist";
          timestamp = "both";
          large_image = "notes";
          small_image = "";
          large_text = "$album";
          small_text = "";
        };
      };
    };
    systemd.user.services.mpd-discord-rpc = {
      enable = true;
      description = "Discord Rich Presence for MPD";
      documentation = ["https://github.com/JakeStanger/mpd-discord-rpc"];
      wantedBy = ["mpd.service"];
      requires = ["mpd.service"];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${getExe pkg}";
      };
    };
  };
}
