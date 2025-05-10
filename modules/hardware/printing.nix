{
  config,
  lib,
  ...
}: {
  options.cfg.printing.enable = lib.mkEnableOption "printing";
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
