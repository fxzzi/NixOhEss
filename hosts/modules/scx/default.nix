{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.scx.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the scx service and configuration.";
  };
  options.scx.scheduler = lib.mkOption {
    type = lib.types.str;
    default = "scx_lavd";
    description = "Change the scheduler used by scx.";
  };

  config = lib.mkIf config.scx.enable {
    scx = {
      enable = true;
      scheduler = config.scx.scheduler;
      package = pkgs.scx.rustscheds;
    };
  };
}
