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
  config = {
    hardware.bluetooth.enable = cfg.enable;
    environment.systemPackages = mkIf cfg.enable [pkgs.bluetuith];
  };
}
