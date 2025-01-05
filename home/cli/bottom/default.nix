{ ... }:
{
  programs.bottom = {
    enable = true;
    settings = {
      flags = {
        group_processes = true;
        hide_table_gap = true;
        process_memory_as_value = true;
        enable_gpu_memory = true;
      };
      temperature.sensor_filter = {
        list = [
          "VRM"
          "T_Sensor"
          "nct"
        ];
      };
      network.interface_filter = {
        list = [ "virbr0.*" ];
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
    };
  };
}
