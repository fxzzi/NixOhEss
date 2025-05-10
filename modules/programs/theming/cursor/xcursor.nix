{
  pkgs,
  config,
  lib,
  ...
}: let
  cursor = config.cfg.gui.hypr.hyprcursor.theme;
  xcursor =
    if cursor == "posy-cursors"
    then "Posy_Cursor"
    else if cursor == "xcursor-pro"
    then "XCursor-Pro-Light"
    else throw "Invalid cursor theme";
  gtkCursorConf = ''
    gtk-cursor-theme-name=${xcursor}
    gtk-cursor-theme-size=24
  '';
in {
  config = {
    environment.sessionVariables = {
      XCURSOR_THEME = xcursor;
      XCURSOR_SIZE = 24;
      XCURSOR_PATH = [
        "${pkgs.${cursor}}/share/icons"
      ];
    };
    hj = {
      files = {
        # lib.mkAfter places the text at the end of the file.
        ".config/gtk-3.0/settings.ini".text = lib.mkAfter gtkCursorConf;
        ".config/gtk-4.0/settings.ini".text = lib.mkAfter gtkCursorConf;
        ".local/share/icons/default/index.theme".text = ''
          [Icon Theme]
          Inherits=${xcursor}
        '';
      };
      packages = [
        pkgs.${cursor}
      ];
    };
    programs.hyprland.settings.exec = lib.mkAfter [
      "dconf write /org/gnome/desktop/interface/cursor-theme \"'${xcursor}'\""
      "dconf write /org/gnome/desktop/interface/cursor-size \"'24'\""
    ];
  };
}
