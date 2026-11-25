{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkBefore
    concatLines
    types
    ;
  cfg = config.cfg.programs.thunar;
in
{
  options.cfg.programs.thunar = {
    enable = mkEnableOption "thunar";
    bookmarks = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        GTK sidebar bookmarks, as "<uri> <label>". Definitions from
        multiple files are merged, so hosts can just add their own.
      '';
    };
    view = mkOption {
      type = types.enum [
        "Details"
        "Icon"
        "Compact"
      ];
      default = "Icon";
      description = "The default view for Thunar.";
    };
  };
  config = mkIf cfg.enable {
    # mkBefore so these always come first, above any host bookmarks
    cfg.programs.thunar.bookmarks = mkBefore [
      "file://${config.hj.directory}/Downloads Downloads"
      "file://${config.hj.directory}/Documents Documents"
      "file://${config.hj.directory}/Videos Videos"
      "file://${config.hj.directory}/Pictures Pictures"
      "file://${config.hj.directory}/Pictures/Screenshots Screenshots"
      "file://${config.programs.nh.flake} NixOS"
    ];
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
        _7zip-zstd-rar
      ];
      xdg.config.files = {
        "gtk-3.0/bookmarks".text = concatLines cfg.bookmarks;
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
            <icon>utilities-terminal</icon>
            <name>Edit in Terminal</name>
            <submenu></submenu>
            <unique-id>1715762765914315-1</unique-id>
            <command>xdg-terminal-exec nvim %f</command>
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
            <command>xdg-terminal-exec --dir=%f</command>
            <description></description>
            <range>*</range>
            <patterns>*</patterns>
            <directories/>
          </action>
          </actions>
        '';
      };
    };
    environment.etc."xdg/xfce4/xfconf/xfce-perchannel-xml/thunar.xml".text = ''
      <?xml version="1.1" encoding="UTF-8"?>

      <channel name="thunar" version="1.0">
        <property name="default-view" type="string" value="Thunar${cfg.view}View" locked="*" unlocked="root"/>
        <property name="last-window-maximized" type="bool" value="true" locked="*" unlocked="root"/>
        <property name="last-show-hidden" type="bool" value="true" locked="*" unlocked="root"/>

        <property name="hidden-bookmarks" type="array" locked="*" unlocked="root">
          <value type="string" value="network:///"/>
          <value type="string" value="computer:///"/>
          <value type="string" value="recent:///"/>
          <value type="string" value="file://${config.hj.directory}/Desktop"/>
        </property>

        <property name="misc-directory-specific-settings" type="bool" value="true" locked="*" unlocked="root"/>
        <property name="misc-date-style" type="string" value="THUNAR_DATE_STYLE_SHORT" locked="*" unlocked="root"/>
        <property name="misc-volume-management" type="bool" value="false" locked="*" unlocked="root"/>
        <property name="misc-exec-shell-scripts-by-default" type="string" value="THUNAR_EXECUTE_SHELL_SCRIPT_ASK" locked="*" unlocked="root"/>
        <property name="misc-highlighting-enabled" type="bool" value="false" locked="*" unlocked="root"/>
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
