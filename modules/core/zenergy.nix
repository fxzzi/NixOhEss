{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.core.kernel.zenergy;
in {
  options.cfg.core.kernel.zenergy.enable = mkEnableOption "zenergy";
  config = mkIf cfg.enable {
    boot = {
      kernelModules = ["nct6775"]; # provides temp readings
      extraModulePackages = with config.boot.kernelPackages; [zenergy]; # provides power readings
    };
  };
}
