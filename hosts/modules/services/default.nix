{
  config,
  lib,
  pkgs,
  ...
}: {
  options.services.cups.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables cups for printing";
  };
  options.services.wootingRules.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables wooting udev rules";
  };
  config = {
    services.printing.enable = config.services.cups.enable;
    services.udev.packages = lib.mkIf config.services.wootingRules.enable [pkgs.wooting-udev-rules];
  };
}
