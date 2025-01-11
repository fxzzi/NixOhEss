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
      mimeApps = {
        enable = true;
        defaultApplications = {
          # Browser-related formats
          "application/xhtml+xml" = "librewolf.desktop";
          "text/html" = "librewolf.desktop";
          "text/xml" = "librewolf.desktop";
          "x-scheme-handler/ftp" = "librewolf.desktop";
          "x-scheme-handler/http" = "librewolf.desktop";
          "x-scheme-handler/https" = "librewolf.desktop";

          # File Manager
          "inode/directory" = "thunar.desktop";

          # Archive formats
          "application/zip" = "org.gnome.FileRoller.desktop";
          "application/vnd.rar" = "org.gnome.FileRoller.desktop";
          "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
          "application/x-tar" = "org.gnome.FileRoller.desktop";
          "application/gzip" = "org.gnome.FileRoller.desktop";
          "application/x-bzip" = "org.gnome.FileRoller.desktop";
          "application/x-bzip2" = "org.gnome.FileRoller.desktop";
          "application/x-xz" = "org.gnome.FileRoller.desktop";
          "application/x-rar-compressed" = "org.gnome.FileRoller.desktop";

          # PDF Viewer
          "application/pdf" = "atril.desktop";

          # Image Viewer
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
