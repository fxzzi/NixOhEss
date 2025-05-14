{
  lib,
  config,
  ...
}: {
  options.cfg.xdgConfig.enable = lib.mkEnableOption "xdgConfig";
  config = lib.mkIf config.cfg.xdgConfig.enable {
    xdg.mime.defaultApplications = {
      "application/pdf" = "atril.desktop";

      "image/png" = "eom.desktop";
      "image/jpeg" = "eom.desktop";
      "image/jpg" = "eom.desktop";
      "image/gif" = "eom.desktop";
      "image/webp" = "eom.desktop";
      "image/bmp" = "eom.desktop";
      "image/tiff" = "eom.desktop";
      "image/svg+xml" = "eom.desktop";
    };
  };
}
