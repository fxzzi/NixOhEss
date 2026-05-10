{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf concatMapStrings;
  cfg = config.cfg.programs.thunar;
  bookmarks = [
    "file://${config.hj.directory}/Downloads Downloads"
    "file://${config.hj.directory}/Videos Videos"
    "file://${config.hj.directory}/Pictures/Screenshots Screenshots"
    "file://${config.hj.directory}/.config/nixos NixOS"
  ];
in {
  options.cfg.programs.thunar = {
    enable = mkEnableOption "thunar";
    collegeBookmarks.enable = mkEnableOption "collegeBookmarks";
  };
  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
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
        package = pkgs.gvfs;
      };
    };
    hj = {
      packages = with pkgs; [
        file-roller
        unrar
        rar
        p7zip
      ];
      xdg.config.files = {
        "gtk-3.0/bookmarks".text = concatMapStrings (l: l + "\n") bookmarks;
        "Thunar/uca.xml".text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <actions>
          <action>
            <icon>clipboard</icon>
            <name>Copy as Path</name>
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
            <name>Open Terminal here</name>
            <submenu></submenu>
            <unique-id>1715763119333224-2</unique-id>
            <command>foot -D %f</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <directories/>
          </action>
          </actions>
        '';
      };
    };
    # most useful options are the two bottom ones, which ensures that all new directories open sorted by name ascending.
    environment.etc."xdg/xfce4/xfconf/xfce-perchannel-xml/thunar.xml".text = ''
      <?xml version="1.1" encoding="UTF-8"?>

      <channel name="thunar" version="1.0">
        <property name="last-view" type="string" value="ThunarIconView" locked="*" unlocked="root"/>
        <property name="last-icon-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_100_PERCENT" locked="*" unlocked="root"/>
        <property name="last-window-maximized" type="bool" value="true" locked="*" unlocked="root"/>
        <property name="last-show-hidden" type="bool" value="true" locked="*" unlocked="root"/>
        <property name="hidden-bookmarks" type="array" locked="*" unlocked="root">
          <value type="string" value="network:///"/>
        </property>
        <property name="misc-single-click" type="bool" value="false" locked="*" unlocked="root"/>
        <property name="misc-directory-specific-settings" type="bool" value="true" locked="*" unlocked="root"/>
        <property name="misc-date-style" type="string" value="THUNAR_DATE_STYLE_SHORT" locked="*" unlocked="root"/>
        <property name="misc-use-csd" type="bool" value="false" locked="*" unlocked="root"/>
        <property name="misc-symbolic-icons-in-sidepane" type="bool" value="false" locked="*" unlocked="root"/>
        <property name="misc-show-delete-action" type="bool" value="false" locked="*" unlocked="root"/>
        <property name="misc-volume-management" type="bool" value="false" locked="*" unlocked="root"/>
        <property name="misc-exec-shell-scripts-by-default" type="string" value="THUNAR_EXECUTE_SHELL_SCRIPT_ASK" locked="*" unlocked="root"/>
        <property name="misc-folders-first" type="bool" value="true" locked="*" unlocked="root"/>

        <property name="default-view" type="string" value="ThunarIconView" locked="*" unlocked="root"/>
        <property name="misc-highlighting-enabled" type="bool" value="false" locked="*" unlocked="root"/>
        <property name="last-sort-order" type="string" value="GTK_SORT_ASCENDING" locked="*" unlocked="root"/>
        <property name="last-sort-column" type="string" value="THUNAR_COLUMN_NAME" locked="*" unlocked="root"/>
      </channel>
    '';
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
