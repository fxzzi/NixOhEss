{
  config,
  lib,
  ...
}: {
  options.cfg.kernel.v4l2.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to enable v4l2loopback module or not";
  };
  config = lib.mkIf config.cfg.kernel.v4l2.enable {
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
