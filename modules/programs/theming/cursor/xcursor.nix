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
    else if cursor == "bibata-hyprcursor"
    then "Bibata-Original-Classic"
    else throw "Invalid cursor theme";
  xcursorPkg =
    if cursor == "bibata-hyprcursor"
    then pkgs.bibata-cursors
    else pkgs.${cursor};
  gtkCursorConf = ''
    gtk-cursor-theme-name=${xcursor}
    gtk-cursor-theme-size=24
  '';
  dconf = lib.getExe pkgs.dconf;
in {
  config = {
    environment.sessionVariables = {
      XCURSOR_THEME = xcursor;
      XCURSOR_SIZE = 24;
      XCURSOR_PATH = [
        "${xcursorPkg}/share/icons"
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
        xcursorPkg
      ];
    };
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = xcursor;
            cursor-size = lib.gvariant.mkInt32 24;
          };
        };
      }
    ];
  };
}
