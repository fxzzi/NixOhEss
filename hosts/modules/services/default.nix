{
  config,
  lib,
  pkgs,
  ...
}: {
  options.services = {
    wootingRules.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables wooting udev rules";
    };
    scyroxRules.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables scyrox udev rules";
    };
  };
  config = {
    services = {
      udev = {
        packages = lib.mkIf config.services.wootingRules.enable [pkgs.wooting-udev-rules];
        extraRules = lib.mkIf config.services.scyroxRules.enable ''
          # scyrox vendor id
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3554", TAG+="uaccess"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="3554", TAG+="uaccess"
        '';
      };
    };
  };
}
