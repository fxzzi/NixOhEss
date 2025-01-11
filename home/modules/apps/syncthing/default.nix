{
  user,
  hostName,
  ...
}: let
  sendOrRecieve =
    if hostName == "fazziPC"
    then "sendonly"
    else if hostName == "fazziGO"
    then "recieveonly"
    else null;
in {
  config = {
    services.syncthing = {
      enable = true;
      tray.enable = true;
      settings = {
        devices = {
          "Pissel 7" = {
            id = "E7S5TI3-Z6VYMFB-EL7NZCS-JXQQFMO-7ZQ7U4U-YS6XZLJ-EP7CDON-M4AC7QK";
          };
          "fazziPC" = {
            id = "MH7YT2L-5GGIWNU-OXJG2HU-2DPOUWP-NDZ43FK-WSRJXBR-M7I3S33-OVJHQQX";
          };
          "fazziGO" = {
            id = "364UYNQ-SA7D3BC-DSZWRDU-JIK4I2T-Q4DKAIN-VAFPU33-HAKKJNN-BKXLNQ3";
          };
        };
        folders = {
          "/home/${user}/Music" = {
            id = "music";
            label = "Music";
            type = sendOrRecieve;
            devices = ["fazziPC" "fazziGO" "Pissel 7"];
          };
        };
      };
    };
  };
}
