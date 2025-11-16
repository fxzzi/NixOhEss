{
  pkgs,
  self',
  lib,
  ...
}: let
  qt6ct = self'.packages.qt6ct-kde;
in {
  config = {
    environment = {
      sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt6ct";
      };
    };
    hj = {
      xdg.config.files."qt6ct/qt6ct.conf" = {
        generator = lib.generators.toINI {};
        value = {
          Appearance = {
            icon_theme = "Papirus-Dark";
            custom_palette = true;
            standard_dialogs = "xdgdesktopportal";
            style = "Adwaita-Dark";
          };
          Fonts = {
            fixed = ''"monospace,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
            general = ''"sans-serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
          };
        };
      };
      packages = with pkgs; [
        (symlinkJoin {
          inherit (qt6ct) name pname version meta;
          paths = [qt6ct];
          # remove the qt6ct .desktop file. It's not like
          # we can modify settings in there anyway.
          postBuild = ''
            unlink $out/share/applications/qt6ct.desktop
          '';
        })
        adwaita-qt
        adwaita-qt6
      ];
    };
  };
}
