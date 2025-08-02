{
  lib,
  config,
  pkgs,
  ... 
}: {
  options.cfg.services.scx.enable = lib.mkEnableOption "scx";
  options.cfg.services.scx.scheduler = lib.mkOption {
    type = lib.types.str;
    default = "scx_lavd";
    description = "Change the scheduler used by scx.";
  };
  options.cfg.services.scx.flags = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "add flags to your chosen scheduler.";
  };

  config = lib.mkIf config.cfg.services.scx.enable {
    services.scx = {
      enable = true;
      inherit (config.cfg.services.scx) scheduler;
      extraArgs = config.cfg.services.scx.flags;
      package = pkgs.scx.rustscheds;
    };
  };
}
