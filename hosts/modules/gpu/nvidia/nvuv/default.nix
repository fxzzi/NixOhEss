{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  options.gpu.nvidia.nvuv.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the nvuv undervolt service.";
  };
  options.gpu.nvidia.nvuv.maxClock = lib.mkOption {
    type = lib.types.int;
    default = 0;
    description = "Changes the max clock passed into nvuv.";
  };
  options.gpu.nvidia.nvuv.coreOffset = lib.mkOption {
    type = lib.types.int;
    default = 0;
    description = "Changes the core offset passed into nvuv.";
  };
  options.gpu.nvidia.nvuv.memOffset = lib.mkOption {
    type = lib.types.int;
    default = 0;
    description = "Changes the memory offset passed into nvuv.";
  };
  options.gpu.nvidia.nvuv.powerLimit = lib.mkOption {
    type = lib.types.int;
    default = 0;
    description = "Changes the power limit passed into nvuv";
  };

  config = lib.mkIf config.gpu.nvidia.nvuv.enable {
    services.nvidia-undervolt = {
      description = "NVidia Undervolting script";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${
          lib.getExe inputs.nvuv.packages.${pkgs.system}.nvuv
        } ${config.gpu.nvidia.nvuv.maxClock} ${config.gpu.nvidia.nvuv.coreOffset} ${config.gpu.nvidia.nvuv.memOffset} ${config.gpu.nvidia.nvuv.powerLimit}";
      };
    };
  };
}
