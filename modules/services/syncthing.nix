{
  lib,
  config,
  hostName,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.syncthing;
in {
  options.cfg.services.syncthing.enable = mkEnableOption "syncthing";
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      # avoid using slow relays
      openDefaultPorts = true;
      dataDir = config.hj.directory;
      group = "users";
      user = config.cfg.core.username;
      settings = {
        devices = {
          "fazziPC".id = "XLI5OMS-7DDAHH3-N4WSXUV-T7VDUT2-BOB6G6V-7C44VO6-EDFGUA2-KOLUEQT";
          "fazziGO".id = "LLUHUU4-AY7D7DI-6NPBBWJ-2RTPT67-PHXH23H-3RPVPIF-2CEEDW2-DJZPMAD";
          "fazphone".id = "KDTBUJE-6DU5J27-7UYQE26-QBMFOT2-4IW4QZE-XDSCTUK-LYDB3QO-ZA3MYQ6";
        };
        folders = {
          "music" = {
            id = "music";
            label = "Music";
            path = "~/Music";
            # fazziPC is the main device, so send music to others and don't receive
            # the other devices can send and receive between each other though.
            type =
              if hostName == "fazziPC"
              then "sendonly"
              else "sendreceive";
            devices = ["fazziPC" "fazziGO" "fazphone"];
            ignorePatterns = [
              ".thumbnails"
              ".database_uuid"
              ".nomedia"
            ];
          };
        };
      };
    };
    # Delay syncthing to after boot, to speed up boot
    systemd.services.syncthing-init = {
      wantedBy = lib.mkForce ["default.target"];
      after = lib.mkForce ["syncthing.service" "default.target"];
    };
  };
}
