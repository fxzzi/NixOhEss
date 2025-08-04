{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkAfter gvariant;
  cfg = config.programs.hyprland;
  gtkCursorConf = ''
    gtk-cursor-theme-name=Bibata-Original-Classic
    gtk-cursor-theme-size=24
  '';
in {
  config = mkIf cfg.enable {
    environment.sessionVariables = {
      HYPRCURSOR_THEME = "Bibata-original";
      HYPRCURSOR_SIZE = 24;
      XCURSOR_THEME = "Bibata-Original-Classic";
      XCURSOR_SIZE = "24";
      # as a list to append instead of overwrite to the env var.
      XCURSOR_PATH = ["${pkgs.bibata-cursors}/share/icons"];
    };
    hj = {
      xdg = {
        config.files = {
          "gtk-3.0/settings.ini".text = mkAfter gtkCursorConf;
          "gtk-4.0/settings.ini".text = mkAfter gtkCursorConf;
        };
        data.files."icons/default/index.theme".text = ''
          [Icon Theme]
          Inherits=Bibata-Original-Classic
        '';
      };
      packages = [
        (pkgs.callPackage ./bibata-hyprcursor {})
        pkgs.bibata-cursors
      ];
    };
    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            cursor-theme = "Bibata-Original-Classic";
            cursor-size = gvariant.mkInt32 24;
          };
        };
      }
    ];
  };
}
