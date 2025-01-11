{
  user,
  hostName,
  lib,
  ...
}: let
  sendOrRecieve =
    if hostName == "fazziPC"
    then "sendonly"
    else if hostName == "fazziGO"
    then "receiveonly"
    else null;
  otherHost =
    if hostName == "fazziPC"
    then "fazziGO"
    else if hostName == "fazziGO"
    then "fazziPC"
    else null;
in {
  config = {
    services.syncthing = {
      enable = true;
      settings = {
        devices = {
          "Pissel 7" = {
            id = "E7S5TI3-Z6VYMFB-EL7NZCS-JXQQFMO-7ZQ7U4U-YS6XZLJ-EP7CDON-M4AC7QK";
          };
          "fazziPC" = lib.mkIf (hostName != "fazziPC") {
            id = "X47FEBP-ZQCSV2U-SJTHU36-CFJYJHG-Z6W3Y4M-6UEPHRZ-KGDXZQZ-4OQK7AU";
          };
          "fazziGO" = lib.mkIf (hostName != "fazziGO") {
            id = "364UYNQ-SA7D3BC-DSZWRDU-JIK4I2T-Q4DKAIN-VAFPU33-HAKKJNN-BKXLNQ3";
          };
        };
        folders = {
          "~/Music" = {
            id = "music";
            label = "Music";
            type = sendOrRecieve;
            devices = [otherHost "Pissel 7"];
          };
        };
      };
    };
  };
}
