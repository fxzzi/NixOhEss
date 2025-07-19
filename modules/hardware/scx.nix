{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cfg.scx.enable = lib.mkEnableOption "scx";
  options.cfg.scx.scheduler = lib.mkOption {
    type = lib.types.str;
    default = "scx_lavd";
    description = "Change the scheduler used by scx.";
  };
  options.cfg.scx.flags = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "add flags to your chosen scheduler.";
  };

  config = lib.mkIf config.cfg.scx.enable {
    services.scx = {
      enable = true;
      inherit (config.cfg.scx) scheduler;
      extraArgs = config.cfg.scx.flags;
      package = pkgs.scx.rustscheds;
    };
  };
}
