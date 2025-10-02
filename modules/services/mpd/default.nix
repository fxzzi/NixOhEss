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
  imports = [
    ./mpd-discord-rpc.nix
  ];
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

        # use ffmpeg decoder over opus and vorbis
        # opus decoder is cooked, but mpd will read ogg opus
        # files with vorbis which is obviously wrong. So disable
        # that too.
        decoder {
          plugin "opus"
          enabled "no"
        }
        decoder {
          plugin "vorbis"
          enabled "no"
        }
        decoder {
          plugin "ffmpeg"
          enabled "yes"
        }

        replaygain "track"
        restore_paused "yes"
      '';
    };
    systemd.user.services.mpd = {
      enable = true;
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
        ExecStart = "${getExe pkgs.mpd} --no-daemon";
      };
    };
  };
}
