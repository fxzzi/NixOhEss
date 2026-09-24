{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cfg.hardware.opentabletdriver;
in
{
  options.cfg.hardware.opentabletdriver.enable = mkEnableOption "opentabletdriver";
  config = mkIf cfg.enable {
    hardware.opentabletdriver = {
      enable = true;
    };
  };
}
