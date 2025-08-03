{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.printing;
in {
  options.cfg.services.printing.enable = mkEnableOption "printing";
  config = mkIf cfg.enable {
    services = {
      printing.enable = true;
    };
  };
}
