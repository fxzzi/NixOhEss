{
  lib,
  config,
  ...
}: {
  options.cfg.services.opentabletdriver.enable = lib.mkEnableOption "opentabletdriver";
  config = lib.mkIf config.cfg.services.opentabletdriver.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
