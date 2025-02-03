{
  config,
  lib,
  pkgs,
  ...
}: {
  options.services.wootingRules.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables wooting udev rules";
  };
  config = {
    services.udev.packages = lib.mkIf config.services.wootingRules.enable [pkgs.wooting-udev-rules];
  };
}
