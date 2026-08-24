{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  config = {
    environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
    hj = {
      xdg.config.files = {
        "qt6ct/qt6ct.conf" = {
          generator = lib.generators.toINI { };
          value = {
            Appearance = {
              icon_theme = "Papirus-Dark";
              standard_dialogs = "xdgdesktopportal";
              style = "kvantum-dark";
              custom_palette = true;
            };
            Fonts = {
              fixed = ''"monospace,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
              general = ''"sans-serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
            };
          };
        };
        "Kvantum/Colors".source = "${inputs.KvLibadwaita}/src/Colors";
        "Kvantum/KvLibadwaita".source = "${inputs.KvLibadwaita}/src/KvLibadwaita";
        "Kvantum/kvantum.kvconfig" = {
          generator = lib.generators.toINI { };
          value.General.theme = "KvLibadwaitaDark";
        };
      };
      packages = with pkgs; [
        (symlinkJoin {
          name = "qt-theming";
          paths = [
            qt6Packages.qt6ct
            qt6Packages.qtstyleplugin-kvantum
          ];
          postBuild = ''
            unlink $out/share/applications/qt6ct.desktop
            unlink $out/share/applications/kvantummanager.desktop
          '';
        })
      ];
    };
  };
}
