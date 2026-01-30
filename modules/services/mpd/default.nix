{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.mpd;
in {
  options.cfg.services.mpd.enable = mkEnableOption "mpd";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.mpd
      ];
      xdg.config.files."mpd/mpd.conf".text = ''
        music_directory "~/Music"
        state_file "~/.local/state/mpd/state"
        sticker_file "~/.local/state/mpd/sticker.sql"

        bind_to_address "localhost"

        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }

        # opus decoder incorrectly applies replaygain
        decoder {
          plugin "opus"
          enabled "no"
        }

        replaygain "track"
        restore_paused "yes"
      '';
    };
    systemd.user.services.mpd = {
      description = "Music Player Daemon";
      after = [
        "network.target"
        "sound.target"
      ];
      wantedBy = [
        "default.target"
      ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${getExe pkgs.mpd} --systemd";
      };
    };
  };
}
