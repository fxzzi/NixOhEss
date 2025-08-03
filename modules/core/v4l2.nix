{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.core.kernel.v4l2;
in {
  options.cfg.core.kernel.v4l2.enable = mkEnableOption "v4l2";
  config = mkIf cfg.enable {
    boot = {
      kernelModules = ["v4l2loopback"];
      extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
      extraModprobeConfig = ''
        # exclusive_caps: Chromium, Electron, etc. will only show device when actually streaming
        options v4l2loopback exclusive_caps=1
      '';
    };
  };
}
