{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf concatMapStrings getExe';
  cfg = config.cfg.programs.thunar;
  bookmarks = [
    "file:///home/${config.cfg.core.username}/Downloads Downloads"
    "file:///home/${config.cfg.core.username}/Videos Videos"
    "file:///home/${config.cfg.core.username}/Pictures/Screenshots Screenshots"
    "file:///home/${config.cfg.core.username}/.config/nixos NixOS"
  ];
in {
  options.cfg.programs.thunar = {
    enable = mkEnableOption "thunar";
    collegeBookmarks.enable = mkEnableOption "collegeBookmarks";
  };
  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        # Enable some plugins for archive support
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };
    services = {
      # Thunar thumbnailer
      tumbler.enable = true;
      gvfs = {
        enable = true; # Enable gvfs for stuff like trash, mtp
        package = pkgs.gvfs; # Set to gvfs instead of gnome gvfs
      };
    };

    hj = {
      packages = with pkgs; [
        file-roller
        unrar
        p7zip
      ];
      xdg.config.files = {
        "gtk-3.0/bookmarks".text = concatMapStrings (l: l + "\n") bookmarks;
        "Thunar/uca.xml".text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <actions>
          <action>
            <icon>clipboard</icon>
            <name>Copy File / Folder Path</name>
            <submenu></submenu>
            <unique-id>1653335357081852-1</unique-id>
            <command>echo -n &apos;"%f"&apos; | wl-copy</command>
            <description></description>
            <range></range>
            <patterns>*</patterns>
            <directories/>
            <audio-files/>
            <image-files/>
            <other-files/>
            <text-files/>
            <video-files/>
          </action>
          <action>
            <icon>foot</icon>
            <name>Edit in Terminal</name>
            <submenu></submenu>
            <unique-id>1715762765914315-1</unique-id>
            <command>foot nvim %f</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <other-files/>
            <text-files/>
          </action>
          <action>
            <icon>folder-blue-script</icon>
            <name>Launch Terminal here</name>
            <submenu></submenu>
            <unique-id>1715763119333224-2</unique-id>
            <command>foot -D %f</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <directories/>
          </action>
          <action>
            <icon>utilities-terminal_su</icon>
            <name>Edit as root</name>
            <submenu></submenu>
            <unique-id>1716201472079277-1</unique-id>
            <command>foot ${getExe' pkgs.sudo "sudoedit"} %f</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <other-files/>
            <text-files/>
          </action>
          </actions>
        '';
      };
    };
    xdg.mime.defaultApplications = {
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
    };
  };
}
