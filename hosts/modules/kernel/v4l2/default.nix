{
  config,
  lib,
  ...
}: {
  options.kernel.v4l2.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to enable v4l2loopback module or not";
  };
  config = lib.mkIf config.kernel.v4l2.enable {
    boot = {
      kernelModules = ["v4l2loopback"];
      extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    };
  };
}
