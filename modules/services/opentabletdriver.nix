{
  lib,
  config,
  ...
}: {
  options.cfg.opentabletdriver.enable = lib.mkEnableOption "opentabletdriver";
  config = lib.mkIf config.cfg.opentabletdriver.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
