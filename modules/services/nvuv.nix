{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf getExe;
  inherit (builtins) toString;
  cfg = config.cfg.services.nvuv;
  inherit (inputs.nvuv.packages.${pkgs.stdenv.hostPlatform.system}) nvuv;
in {
  options.cfg = {
    services = {
      nvuv = {
        enable = mkEnableOption "nvidia overclock / undervolt";
        maxClock = mkOption {
          type = types.int;
          default = 0;
          description = "Changes the max clock passed into nvuv.";
        };
        coreOffset = mkOption {
          type = types.int;
          default = 0;
          description = "Changes the core offset passed into nvuv.";
        };
        memOffset = mkOption {
          type = types.int;
          default = 0;
          description = "Changes the memory offset passed into nvuv.";
        };
        powerLimit = mkOption {
          type = types.int;
          default = 0;
          description = "Changes the power limit passed into nvuv";
        };
        tempMonitor = {
          enable = mkEnableOption "nvidia temp monitoring";
          path = mkOption {
            type = types.str;
            default = "/tmp/nvidia-temp";
            description = "Path to the file";
          };
          interval = mkOption {
            type = types.int;
            default = 5;
            description = "How often should we poll for temp";
          };
        };
      };
    };
  };

  config = {
    systemd.services = {
      nvuv = mkIf cfg.enable {
        description = "NVidia Undervolting script";
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          ExecStart = ''
            ${getExe nvuv} \
            --max-clock ${toString cfg.maxClock} \
            --core-offset ${toString cfg.coreOffset} \
            --memory-offset ${toString cfg.memOffset} \
            --power-limit ${toString cfg.powerLimit}
          '';
        };
      };
      nvuv-temp = mkIf cfg.tempMonitor.enable {
        description = "NVidia Temperature monitoring script";
        wantedBy = ["multi-user.target"];
        before = mkIf config.hardware.fancontrol.enable ["fancontrol.service"];
        serviceConfig = {
          ExecStart = ''
            ${getExe nvuv} \
            --temp-daemon \
            --temp-path ${cfg.tempMonitor.path} \
            --temp-interval ${toString cfg.tempMonitor.interval}
          '';
        };
      };
    };
  };
}
