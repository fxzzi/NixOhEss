{
  lib,
  config,
  user,
  hostName,
  ...
}: {
  options.cfg.apps.syncthing.enable = lib.mkEnableOption "syncthing";
  config = lib.mkIf config.cfg.apps.syncthing.enable {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      dataDir = "/home/${user}";
      group = "users";
      inherit user;
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
            type =
              if hostName == "fazziPC"
              then "sendonly"
              else "receiveonly";
            devices = ["fazziPC" "fazziGO" "Pissel 7"];
          };
        };
      };
    };
  };
}
