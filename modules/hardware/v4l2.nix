{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.hardware.v4l2;
in {
  options.cfg.hardware.v4l2.enable = mkEnableOption "v4l2";
  config = mkIf cfg.enable {
    boot = {
      kernelModules = ["v4l2loopback"];
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      extraModprobeConfig = ''
        # exclusive_caps: Chromium, Electron, etc. will only show device when actually streaming
        options v4l2loopback exclusive_caps=1
      '';
    };
  };
}
