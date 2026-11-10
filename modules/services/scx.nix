{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.cfg.services.scx;
in
{
  options.cfg.services.scx = {
    enable = mkEnableOption "scx";
    scheduler = mkOption {
      type = types.str;
      default = "scx_lavd";
      description = "Change the scheduler used by scx.";
    };
  };

  config = mkIf cfg.enable {
    services.scx-loader = {
      enable = true;
      schedsPackages = [ pkgs.scx.rustscheds ];
      config = {
        default_sched = cfg.scheduler;
      };
    };
  };
}
