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
    ./mpd-discord-rpc
  ];
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.mpd
      ];
      files = {
        ".config/mpd/mpd.conf".text = ''
          music_directory "/home/${config.cfg.core.username}/Music"
          state_file "/home/${config.cfg.core.username}/.local/state/mpd/state"
          sticker_file "/home/${config.cfg.core.username}/.local/state/mpd/sticker.sql"

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
