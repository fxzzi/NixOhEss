{
  lib,
  config,
  ...
}: {
  options.xdgConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the xdg config and customisation.";
  };
  config = lib.mkIf config.xdgConfig.enable {
    home.preferXdgDirectories = true;
    xdg = {
      enable = true;
      mime.enable = true;
      userDirs.enable = true;
      configFile."mimeapps.list".force = true; # don't error when mimeapps.list is replaced, it gets replaced often
      mimeApps = {
        enable = true;
        defaultApplications = {
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
    };
  };
}
