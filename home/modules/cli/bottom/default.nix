{
  lib,
  config,
  ...
}: {
  options.cli.bottom.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the btm (bottom) system monitor";
  };
  config = lib.mkIf config.cli.bottom.enable {
    programs.bottom = {
      enable = true;
      settings = {
        flags = {
          group_processes = true;
          hide_table_gap = true;
          process_memory_as_value = true;
          enable_gpu = true;
        };
        temperature.sensor_filter = {
          list = [
            "VRM"
            "T_Sensor"
            "nct"
          ];
        };
        network.interface_filter = {
          list = ["virbr0.*"];
        };
        disk.mount_filter = {
          list = [
            "/mnt"
            "/home"
            "/games"
            "/nix"
            "/nix/store/"
          ];
        };
        row = [
          {
            ratio = 30;
            child = [
              {
                ratio = 65;
                type = "cpu";
              }
              {
                ratio = 35;
                type = "net";
              }
            ];
          }
          {
            ratio = 30;
            child = [
              {
                ratio = 40;
                type = "temp";
              }
              {
                ratio = 60;
                type = "disk";
              }
            ];
          }
          {
            ratio = 40;
            child = [
              {
                ratio = 45;
                type = "mem";
              }
              {
                ratio = 55;
                type = "proc";
                default = true;
              }
            ];
          }
        ];
      };
    };
    # hide bottom .desktop, its useless tbh
    xdg.desktopEntries = {
      bottom = {
        name = "bottom";
        noDisplay = true;
        exec = "";
      };
    };
  };
}
