{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.cfg.services.sunshine;
in {
  options.cfg.services.sunshine.enable = mkEnableOption "sunshine";
  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
      autoStart = false;
    };
  };
}
