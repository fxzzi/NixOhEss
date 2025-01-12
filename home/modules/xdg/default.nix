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
          "application/xhtml+xml" = "librewolf.desktop";
          "text/html" = "librewolf.desktop";
          "text/xml" = "librewolf.desktop";
          "x-scheme-handler/ftp" = "librewolf.desktop";
          "x-scheme-handler/http" = "librewolf.desktop";
          "x-scheme-handler/https" = "librewolf.desktop";

          "inode/directory" = "thunar.desktop";

          "application/zip" = "org.gnome.FileRoller.desktop";
          "application/vnd.rar" = "org.gnome.FileRoller.desktop";
          "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
          "application/x-tar" = "org.gnome.FileRoller.desktop";
          "application/gzip" = "org.gnome.FileRoller.desktop";
          "application/x-bzip" = "org.gnome.FileRoller.desktop";
          "application/x-bzip2" = "org.gnome.FileRoller.desktop";
          "application/x-xz" = "org.gnome.FileRoller.desktop";
          "application/x-rar-compressed" = "org.gnome.FileRoller.desktop";

          "application/pdf" = "atril.desktop";

          "image/png" = "eom.desktop";
          "image/jpeg" = "eom.desktop";
          "image/jpg" = "eom.desktop";
          "image/gif" = "eom.desktop";
          "image/webp" = "eom.desktop";
          "image/bmp" = "eom.desktop";
          "image/tiff" = "eom.desktop";
          "image/svg+xml" = "eom.desktop";

          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop"; # MKV
          "video/webm" = "mpv.desktop";
          "video/ogg" = "mpv.desktop";
          "audio/mpeg" = "mpv.desktop"; # MP3
          "audio/ogg" = "mpv.desktop";
          "audio/flac" = "mpv.desktop";
          "audio/wav" = "mpv.desktop";
          "audio/aac" = "mpv.desktop";
        };
      };
    };
  };
}
