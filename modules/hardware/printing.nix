{
  config,
  lib,
  ...
}: {
  options.cfg.printing.enable = lib.mkEnableOption "printing";
  config = lib.mkIf config.cfg.printing.enable {
    services = {
      printing.enable = true;
    };
  };
}
