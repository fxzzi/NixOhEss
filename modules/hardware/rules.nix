{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.hardware = {
    wootingRules.enable = lib.mkEnableOption "wootingRules";
    scyroxRules.enable = lib.mkEnableOption "scyroxRules";
    viaRules.enable = lib.mkEnableOption "viaRules";
  };

  config = {
    services.udev = {
      packages = lib.mkMerge [
        (lib.mkIf config.cfg.hardware.wootingRules.enable [pkgs.wooting-udev-rules])
        (lib.mkIf config.cfg.hardware.viaRules.enable [
          pkgs.via
        ])
      ];

      extraRules = lib.mkMerge [
        (lib.mkIf config.cfg.hardware.scyroxRules.enable ''
          # scyrox vendor id
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3554", TAG+="uaccess"
          SUBSYSTEM=="usb", ATTRS{idVendor}=="3554", TAG+="uaccess"
        '')
        ''
          # Disable dualsense acting as touchpad
          ACTION=="add|change", KERNEL=="event[0-9]*", ATTRS{name}=="*Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ''
      ];
    };
  };
}
