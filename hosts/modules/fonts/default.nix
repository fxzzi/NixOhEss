{
  config,
  lib,
  ...
}: {
  options.cfg.fontConfig.subpixelLayout = lib.mkOption {
    type = lib.types.enum [
      "none"
      "rgb"
      "bgr"
      "vrgb"
      "vbgr"
    ];
    default = "rgb";
    description = "Choose the subpixel layout of your main monitor.";
  };
  options.cfg.fontConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enables the basic font configurations.";
  };
  config = lib.mkIf config.cfg.fontConfig.enable {
    fonts = {
      enableDefaultPackages = false;
      fontconfig = {
        subpixel.rgba = config.cfg.fontConfig.subpixelLayout;
        # fixes emojis on browser
        useEmbeddedBitmaps = true;
      };
    };
  };
}
