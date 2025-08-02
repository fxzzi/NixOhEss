{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cfg.hardware.rules = {
    wooting.enable = lib.mkEnableOption "wootingRules";
    scyrox.enable = lib.mkEnableOption "scyroxRules";
    via.enable = lib.mkEnableOption "viaRules";
  };

  config = {
    services.udev = {
      packages = [
        (lib.mkIf config.cfg.hardware.rules.wooting.enable pkgs.wooting-udev-rules)
        (lib.mkIf config.cfg.hardware.rules.via.enable pkgs.via)
      ];

      extraRules = lib.mkMerge [
        (lib.mkIf config.cfg.hardware.rules.scyrox.enable ''
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
