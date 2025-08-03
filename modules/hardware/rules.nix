{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.cfg.hardware.rules;
in {
  options.cfg.hardware.rules = {
    wooting.enable = mkEnableOption "wootingRules";
    scyrox.enable = mkEnableOption "scyroxRules";
    via.enable = mkEnableOption "viaRules";
  };

  config = {
    services.udev = {
      packages = [
        (mkIf cfg.wooting.enable pkgs.wooting-udev-rules)
        (mkIf cfg.via.enable pkgs.via)
      ];

      extraRules = mkMerge [
        (mkIf cfg.scyrox.enable ''
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
