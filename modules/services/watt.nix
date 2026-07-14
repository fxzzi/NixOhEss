{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.watt;
in {
  options.cfg.services.watt.enable = mkEnableOption "watt";
  config = mkIf cfg.enable {
    services.watt.enable = true;
  };
}
