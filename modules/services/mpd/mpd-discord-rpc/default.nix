{
  lib,
  config,
  pkgs,
  npins,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
  fmt = cfg: tomlFormat.generate "config.toml" cfg;
  pkg = pkgs.mpd-discord-rpc.overrideAttrs (
    finalAttrs: {
      src = npins.mpd-discord-rpc;

      cargoDeps = pkgs.rustPackages.rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src;
        hash = "sha256-Q7QyJh/KOJ5drud/tPKtEzfr3q7yosW8wUCOCA8uDSs=";
      };
    }
  );
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
            timestamp = "both";
            large_image = "notes";
            small_image = "";
            large_text = "";
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
        ExecStart = "${lib.getExe pkg}";
      };
    };
  };
}
