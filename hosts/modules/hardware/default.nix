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
    services.udev = {
      packages = lib.mkMerge [
        (lib.mkIf config.cfg.hardware.wootingRules.enable [pkgs.wooting-udev-rules])
        (lib.mkIf config.cfg.hardware.viaRules.enable [
          pkgs.via
          pkgs.qmk-udev-rules
        ])
      ];

      extraRules = ''
        ${lib.optionalString config.cfg.hardware.scyroxRules.enable ''
          # Compx (Scyrox) vendor id
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3554", TAG+="uaccess"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="3554", TAG+="uaccess"
        ''}

        ${lib.optionalString config.cfg.hardware.viaRules.enable ''
          # RDR (SK) vendor id
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="320f", TAG+="uaccess"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="320f", TAG+="uaccess"
        ''}
      '';
    };
  };
}
