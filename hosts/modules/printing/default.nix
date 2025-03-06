{
  config,
  lib,
  ...
}: {
  options.cfg.printing.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables cups for printing";
  };
  config = lib.mkIf config.cfg.printing.enable {
    services = {
      printing.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
