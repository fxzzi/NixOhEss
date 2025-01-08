{
  config,
  lib,
  ...
}:
{
  options.fontConfig.subpixelLayout = lib.mkOption {
    type = lib.types.enum [
      "rgb"
      "bgr"
    ];
    default = "rgb";
    description = "Selects which kernel you would like to use: 'latest' or 'zen'.";
  };
  config = lib.mkIf config.fontConfig.subpixelLayout {
    fonts.fontconfig = {
      subpixel.rgba = config.fonts.subpixelLayout;
      # fixes emojis on browser
      useEmbeddedBitmaps = true;
    };
  };
}
