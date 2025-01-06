{
  config,
  lib,
  ...
}:
{
  fonts.fontconfig = {
    # main PC monitor is bgr
    subpixel.rgba = lib.mkIf (config.networking.hostName == "fazziPC") "bgr";
    # fixes emojis on browser
    useEmbeddedBitmaps = true;
  };
}
