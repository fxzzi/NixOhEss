{
  lib,
  config,
  ...
}: {
  options.cfg.opentabletdriver.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the opentabletdriver daemon";
  };
  config = lib.mkIf config.cfg.opentabletdriver.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
