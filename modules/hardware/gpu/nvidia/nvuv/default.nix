{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.cfg.hardware.nvidia.nvuv;
in {
  options.cfg = {
    hardware = {
      nvidia = {
        nvuv = {
          enable = lib.mkEnableOption "nvidia";
          maxClock = lib.mkOption {
            type = lib.types.int;
            default = 0;
            description = "Changes the max clock passed into nvuv.";
          };
          coreOffset = lib.mkOption {
            type = lib.types.int;
            default = 0;
            description = "Changes the core offset passed into nvuv.";
          };
          memOffset = lib.mkOption {
            type = lib.types.int;
            default = 0;
            description = "Changes the memory offset passed into nvuv.";
          };
          powerLimit = lib.mkOption {
            type = lib.types.int;
            default = 0;
            description = "Changes the power limit passed into nvuv";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nvuv = {
      description = "NVidia Undervolting script";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = ''
          ${lib.getExe inputs.nvuv.packages.${pkgs.system}.nvuv} \
          ${builtins.toString cfg.maxClock} \
          ${builtins.toString cfg.coreOffset} \
          ${builtins.toString cfg.memOffset} \
          ${builtins.toString cfg.powerLimit}
        '';
      };
    };
  };
}
