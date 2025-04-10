{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.hardware = {
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
    viaRules.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable required udev rules for VIA and QMK.";
    };
  };

  config = {
    environment.systemPackages = lib.mkIf config.cfg.hardware.viaRules.enable [
      pkgs.via
    ];

    services.udev = {
      packages = lib.mkMerge [
        (lib.mkIf config.cfg.hardware.wootingRules.enable [pkgs.wooting-udev-rules])
        (lib.mkIf config.cfg.hardware.viaRules.enable [
          pkgs.via
        ])
      ];

      extraRules = lib.mkIf config.cfg.hardware.scyroxRules.enable ''
        # scyrox vendor id
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3554", TAG+="uaccess"
        SUBSYSTEM=="usb", ATTRS{idVendor}=="3554", TAG+="uaccess"
      '';
    };
  };
}
