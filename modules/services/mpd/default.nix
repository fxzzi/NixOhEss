{
  config,
  lib,
  pkgs,
  user,
  ...
}: {
  options.cfg.music.mpd.enable = lib.mkEnableOption "mpd";
  imports = [
    ./mpd-discord-rpc
  ];
  config = lib.mkIf config.cfg.music.mpd.enable {
    hj = {
      packages = [
        pkgs.mpd
      ];
      files = {
        ".config/mpd/mpd.conf".text = ''
          music_directory "/home/${user}/Music"
          state_file "${config.hj.xdg.stateDirectory}/mpd/state"
          sticker_file "${config.hj.xdg.stateDirectory}/mpd/sticker.sql"

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
        ExecStart = "${lib.getExe pkgs.mpd} --no-daemon";
      };
    };
  };
}
