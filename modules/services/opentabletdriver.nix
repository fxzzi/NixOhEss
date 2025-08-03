{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.opentabletdriver;
in {
  options.cfg.services.opentabletdriver.enable = mkEnableOption "opentabletdriver";
  config = mkIf cfg.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
