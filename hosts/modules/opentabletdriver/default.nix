{ lib, config, ... }:
{
  options.opentabletdriver.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the opentabletdriver daemon";
  };
  config = lib.mkIf config.opentabletdriver.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
