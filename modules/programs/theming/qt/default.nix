{
  pkgs,
  lib,
  ...
}: {
  config = {
    environment = {
      sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt6ct";
      };
    };
    hj = {
      files = {
        ".config/qt6ct/qt6ct.conf".text = lib.generators.toINI {} {
          Appearance = {
            icon_theme = "Papirus-Dark";
            custom_palette = true;
            color_scheme_path = "${./qt6ct-tokyonight.conf}";
            standard_dialogs = "xdgdesktopportal";
            style = "Fusion";
          };
          Fonts = {
            fixed = ''"monospace,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
            general = ''"sans-serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
          };
        };
      };
      packages = with pkgs; [
        qt6ct
      ];
    };
  };
}
