{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.hardware.zenergy;
in {
  options.cfg.hardware.zenergy.enable = mkEnableOption "zenergy";
  config = mkIf cfg.enable {
    boot = {
      kernelModules = ["nct6775"]; # provides temp readings
      extraModulePackages = with config.boot.kernelPackages; [zenergy]; # provides power readings
    };
  };
}
