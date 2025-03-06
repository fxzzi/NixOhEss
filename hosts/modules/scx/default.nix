{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cfg.scx.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the scx service and configuration.";
  };
  options.cfg.scx.scheduler = lib.mkOption {
    type = lib.types.str;
    default = "scx_lavd";
    description = "Change the scheduler used by scx.";
  };

  config = lib.mkIf config.cfg.scx.enable {
    services.scx = {
      enable = true;
      inherit (config.cfg.scx) scheduler;
      package = pkgs.scx.rustscheds;
    };
  };
}
