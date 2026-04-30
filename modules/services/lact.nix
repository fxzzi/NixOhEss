{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.lact;
in {
  options.cfg.services.lact.enable = mkEnableOption "lact";
  config = mkIf cfg.enable {
    services.lact = {
      enable = true;
    };
  };
}
