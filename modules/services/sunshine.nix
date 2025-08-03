{
  lib,
  config,
  ...
}: let
  cfg = config.cfg.services.sunshine;
in {
  options.cfg.services.sunshine.enable = lib.mkEnableOption "sunshine";
  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
      autoStart = false;
    };
  };
}
