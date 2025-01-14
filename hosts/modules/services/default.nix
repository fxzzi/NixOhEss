{
  config,
  lib,
  ...
}: {
  options.services.cups.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables cups for printing";
  };
  config = {
    services.printing.enable = config.services.cups.enable;
  };
}
