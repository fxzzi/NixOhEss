{
  config,
  pkgs,
  lib,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf getExe;
  inherit (builtins) toString;
  cfg = config.cfg.hardware.nvidia.nvuv;
  nvuv = pkgs.callPackage npins.nvuv {};
in {
  options.cfg = {
    hardware = {
      nvidia = {
        nvuv = {
          enable = mkEnableOption "nvidia";
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
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nvuv = {
      description = "NVidia Undervolting script";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = ''
          ${getExe nvuv} \
          ${toString cfg.maxClock} \
          ${toString cfg.coreOffset} \
          ${toString cfg.memOffset} \
          ${toString cfg.powerLimit}
        '';
      };
    };
  };
}
