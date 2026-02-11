{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.cfg.services.watt;
in {
  options.cfg.services.watt.enable = mkEnableOption "watt";
  config = mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = mkForce false;
      watt.enable = true;
    };
  };
  imports = [inputs.watt.nixosModules.default];
}
