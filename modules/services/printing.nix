{
  config,
  lib,
  ...
}: {
  options.cfg.services.printing.enable = lib.mkEnableOption "printing";
  config = lib.mkIf config.cfg.services.printing.enable {
    services = {
      printing.enable = true;
    };
  };
}
