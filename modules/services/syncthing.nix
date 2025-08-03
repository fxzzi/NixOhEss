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
      dataDir = "/home/${config.cfg.core.username}";
      group = "users";
      user = config.cfg.core.username;
      settings = {
        devices = {
          "fazziPC".id = "XLI5OMS-7DDAHH3-N4WSXUV-T7VDUT2-BOB6G6V-7C44VO6-EDFGUA2-KOLUEQT";
          "fazziGO".id = "LLUHUU4-AY7D7DI-6NPBBWJ-2RTPT67-PHXH23H-3RPVPIF-2CEEDW2-DJZPMAD";
          "Pissel 7".id = "GSPX2VJ-WZYZGMB-V4YHAF3-A3JU6CH-TLUHNSM-KQ4IZHY-3I7SWJ7-5BJNMAX";
        };
        folders = {
          "music" = {
            id = "music";
            label = "Music";
            path = "~/Music";
            # fazziPC is the main device, so send music to others and don't receive
            # the other devices can send and receieve between each other though.
            type =
              if hostName == "fazziPC"
              then "sendonly"
              else "sendreceive";
            devices = ["fazziPC" "fazziGO" "Pissel 7"];
          };
        };
      };
    };
  };
}
