{
  lib,
  config,
  ...
}: {
  options.cfg.cli.bottom.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the btm (bottom) system monitor";
  };
  config = lib.mkIf config.cfg.cli.bottom.enable {
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
            # These all show up as 0 degrees.
            "nct6775.656 (nct6798): PCH_CHIP_TEMP"
            "nct6775.656 (nct6798): PCH_CPU_TEMP"
            "nct6775.656 (nct6798): PCH_MCH_TEMP"
            "nct6775.656 (nct6798): PCH_CHIP_CPU_MAX_TEMP"
            "asus-ec-sensors (asusec): T_Sensor"
            "asus-ec-sensors (asusec): VRM"
          ];
        };
        network.interface_filter = {
          list = ["virbr0.*"];
        };
        disk.mount_filter = {
          list = [
            # A lot of these are just the main drive anyway.
            "/mnt"
            "/home"
            "/games"
            "/nix"
            "/nix/store/"
          ];
        };
        # customize the layout of bottom
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
