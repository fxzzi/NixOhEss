{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.core.xdg;
in {
  options.cfg.core.xdg.enable = mkEnableOption "xdgConfig";
  config = mkIf cfg.enable {
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
