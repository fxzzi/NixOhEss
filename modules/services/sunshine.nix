{
  lib,
  config,
  ...
}: {
  options.cfg.services.sunshine.enable = lib.mkEnableOption "sunshine";
  config = lib.mkIf config.cfg.services.sunshine.enable {
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
      autoStart = false;
    };
  };
}
