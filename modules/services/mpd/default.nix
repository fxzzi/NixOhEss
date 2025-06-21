{
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  # NOTE: https://github.com/NixOS/nixpkgs/pull/418139
  package = pkgs.mpd.override {
    liburing = pkgs.liburing.overrideAttrs rec {
      version = "2.11";
      src = pkgs.fetchFromGitHub {
        owner = "axboe";
        repo = "liburing";
        tag = "liburing-${version}";
        hash = "sha256-V73QP89WMrL2fkPRbo/TSkfO7GeDsCudlw2Ut5baDzA=";
      };
    };
  };
in {
  options.cfg.music.mpd.enable = lib.mkEnableOption "mpd";
  imports = [
    ./mpd-discord-rpc
  ];
  config = lib.mkIf config.cfg.music.mpd.enable {
    hj = {
      packages = [
        package
      ];
      files = {
        ".config/mpd/mpd.conf".text = ''
          music_directory "/home/${user}/Music"
          state_file "/home/${user}/.local/state/mpd/state"
          sticker_file "/home/${user}/.local/state/mpd/sticker.sql"

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
        ExecStart = "${lib.getExe package} --no-daemon";
      };
    };
  };
}
