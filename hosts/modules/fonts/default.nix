{
  config,
  lib,
  ...
}: {
  options.fontConfig.subpixelLayout = lib.mkOption {
    type = lib.types.str;
    default = "rgb";
    description = "Choose the subpixel layout of your main monitor.";
  };
  options.fontConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "enables the basic font configurations.";
  };
  config = lib.mkIf config.fontConfig.enable {
    fonts = {
      enableDefaultPackages = false;
      fontconfig = {
        subpixel.rgba = config.fontConfig.subpixelLayout;
        # fixes emojis on browser
        useEmbeddedBitmaps = true;
      };
    };
  };
}
