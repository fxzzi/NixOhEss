{ ... }:
{
  services = {
    mpd = {
      enable = true;
      extraConfig = ''
        bind_to_address    "localhost"

        audio_output {
        	type	"pipewire"
        	name	"PipeWire Sound Server"
        }

        replaygain						"track"
        replaygain_preamp			"4.8"

        restore_paused "yes"
      '';
    };
    mpd-discord-rpc = {
      enable = true;
      settings = {
        hosts = [ "localhost:6600" ];
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
