{
  config,
  lib,
  ...
}: {
  options.cfg.kernel.zenergy.enable = lib.mkEnableOption "zenergy";
  config = lib.mkIf config.cfg.kernel.zenergy.enable {
    boot = {
      kernelModules = ["nct6775"]; # provides temp readings
      extraModulePackages = with config.boot.kernelPackages; [zenergy]; # provides power readings
    };
  };
}
