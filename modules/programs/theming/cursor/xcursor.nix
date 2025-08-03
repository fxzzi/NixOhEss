{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) getExe mkAfter gvariant;
  cfg = config.cfg.programs.hyprland.hyprcursor;
  cursor = cfg.theme;
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
  dconf = getExe pkgs.dconf;
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
      xdg = {
        config = {
          files = {
            "gtk-3.0/settings.ini".text = mkAfter gtkCursorConf;
            "gtk-4.0/settings.ini".text = mkAfter gtkCursorConf;
          };
        };
        data.files."icons/default/index.theme".text = ''
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
            cursor-size = gvariant.mkInt32 24;
          };
        };
      }
    ];
  };
}
