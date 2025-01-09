{
  config,
  lib,
  ...
}: {
  options.music.mpd.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the mpd music server";
  };
  imports = [
    ./mpd-discord-rpc
  ];
  config = lib.mkIf config.music.mpd.enable {
    services = {
      mpd = {
        enable = true;
        extraConfig = ''
          bind_to_address "localhost"

          audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
          }
          replaygain "track"
          replaygain_preamp "4.8"
          restore_paused "yes"
        '';
      };
    };
  };
}
