{
  lib,
  config,
  ...
}: {
  options.music.mpd.discord-rpc.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the mpd rich presence service.";
  };
  config = lib.mkIf config.music.mpd.discord-rpc.enable {
    services.mpd-discord-rpc = {
      enable = true;
      settings = {
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
}
