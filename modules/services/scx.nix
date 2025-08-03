{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.cfg.services.scx;
in {
  options.cfg.services.scx = {
    enable = mkEnableOption "scx";
    scheduler = mkOption {
      type = types.str;
      default = "scx_lavd";
      description = "Change the scheduler used by scx.";
    };
    flags = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "add flags to your chosen scheduler.";
    };
  };

  config = mkIf cfg.enable {
    services.scx = {
      enable = true;
      inherit (cfg) scheduler;
      extraArgs = cfg.flags;
      package = pkgs.scx.rustscheds;
    };
  };
}
