{
  lib,
  pkgs,
  config,
  user,
  ...
}: let
  bookmarks =
    [
      "file:///home/${user}/Downloads Downloads"
      "file:///home/${user}/Videos Videos"
    ]
    ++ lib.optionals config.cfg.apps.thunar.collegeBookmarks.enable [
      "file:///home/${user}/Documents/College/CompSci CompSci"
      "file:///home/${user}/Documents/College/Maths Maths"
      "file:///home/${user}/Documents/College/Physics Physics"
    ]
    ++ [
      "file:///home/${user}/Pictures/Screenshots Screenshots"
      "file://${config.hj.xdg.configDirectory}/nixos NixOS"
    ];
in {
  options.cfg.apps.thunar = {
    enable = lib.mkEnableOption "thunar";
    collegeBookmarks.enable = lib.mkEnableOption "collegeBookmarks";
  };
  config = lib.mkIf config.cfg.apps.thunar.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ]; # Enable some plugins for archive support
    };
    services = {
      tumbler.enable = true; # Thunar thumbnailer
      gvfs.enable = true; # Enable gvfs for stuff like trash, mtp
      gvfs.package = pkgs.gvfs; # Set to gvfs instead of gnome gvfs
    };
    programs.file-roller.enable = true; # Enable File Roller for GUI archive management

    hj = {
      # add some packages for file-roller to work
      packages = with pkgs; [
        p7zip
        unar
      ];
      files = {
        ".config/gtk-3.0/bookmarks".text = lib.concatMapStrings (l: l + "\n") bookmarks;
        ".config/Thunar/uca.xml".text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <actions>
          <action>
            <icon>clipboard</icon>
            <name>Copy File / Folder Path</name>
            <submenu></submenu>
            <unique-id>1653335357081852-1</unique-id>
            <command>echo -n &apos;&quot;%f&quot;&apos; | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}</command>
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
            <command>foot ${lib.getExe' pkgs.sudo "sudoedit"} %f</command>
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
