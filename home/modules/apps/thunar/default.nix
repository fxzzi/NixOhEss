{
  lib,
  pkgs,
  config,
  user,
  hostName,
  ...
}: {
  options.cfg.apps.thunar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables the thunar file manager";
    };
    collegeBookmarks.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables my college bookmarks.";
    };
  };
  config = lib.mkIf config.cfg.apps.thunar.enable {
    # add some packages for file-roller to work
    home.packages = with pkgs; [
      p7zip
      unar
    ];
    # bookmarks for the side pane
    gtk.gtk3.bookmarks =
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
        "file:///home/${user}/.config/nixos NixOS"
      ]
      # If on kunzozPC, also add bookmarks to the windows drives.
      ++ lib.optionals (hostName == "kunzozPC") [
        "file:///mnt/windows-kunzoz Windoes"
        "file:///mnt/windows-dad Job"
      ];
    xdg.mimeApps.defaultApplications = {
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
    xdg.configFile."Thunar/uca.xml".text = ''
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
        <command>${lib.getExe config.programs.foot.package} ${lib.getExe config.programs.nvf.finalPackage} %f</command>
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
        <command>${lib.getExe config.programs.foot.package} -D %f</command>
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
        <command>${lib.getExe config.programs.foot.package} ${lib.getExe' pkgs.sudo "sudoedit"} %f</command>
        <description></description>
        <range>*</range>
        <patterns>*</patterns>
        <other-files/>
        <text-files/>
      </action>
      </actions>
    '';
  };
}
