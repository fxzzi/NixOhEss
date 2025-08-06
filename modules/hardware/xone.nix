{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.core.kernel.xone;
in {
  options.cfg.core.kernel.xone.enable = mkEnableOption "xone";
  config = mkIf cfg.enable {
    hardware.xone.enable = true;
    boot = {
      kernelModules = ["xpad"];
    };
  };
}
