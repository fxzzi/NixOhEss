{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.hardware.zenpower;
in
{
  options.cfg.hardware.zenpower.enable = mkEnableOption "zenpower";
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.zenmonitor ];
    boot = {
      blacklistedKernelModules = [ "k10temp" ];
      kernelModules = [ "nct6775" ]; # provides temp and fan sensors
      extraModulePackages = with config.boot.kernelPackages; [ zenpower ]; # provides power readings
    };
  };
}
