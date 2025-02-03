{
  config,
  lib,
  ...
}: {
  options.printing.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables cups for printing";
  };
  config = lib.mkIf config.printing.enable {
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
