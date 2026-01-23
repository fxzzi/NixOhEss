{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.hardware.bluetooth;
in {
  options.cfg.hardware.bluetooth.enable = mkEnableOption "bluetooth";
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    environment.systemPackages = [pkgs.bluetuith];
  };
}
