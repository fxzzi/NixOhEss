{
  pkgs,
  lib,
  ...
}: let
  style-colors = ''
    [ColorScheme]
    active_colors=#ffeeeeec, #ff373737, #ff515151, #ff444444, #ff1e1e1e, #ff2a2a2a, #ffeeeeec, #ffffffff, #ffeeeeec, #ff2d2d2d, #ff353535, #19000000, #ff15539e, #ffffffff, #ff3584e4, #ff1b6acb, #ff2d2d2d, #ffcdd6f4, #b2262626, #ffffffff, #ffeeeeec, #ff89b4fa
    disabled_colors=#ffa6adc8, #ff1e1e2e, #ffa6adc8, #ff9399b2, #ff45475a, #ff6c7086, #ffa6adc8, #ffa6adc8, #ffa6adc8, #ff1e1e2e, #ff11111b, #ff7f849c, #ff89b4fa, #ff45475a, #ff89b4fa, #fff38ba8, #ff1e1e2e, #ffcdd6f4, #ff11111b, #ffcdd6f4, #807f849c, #ff89b4fa
    inactive_colors=#ffeeeeec, #ff373737, #ff515151, #ff444444, #ff1e1e1e, #ff2a2a2a, #ffeeeeec, #ffffffff, #ffeeeeec, #ff2d2d2d, #ff353535, #19000000, #ff15539e, #ffffffff, #ff3584e4, #ff1b6acb, #ff2d2d2d, #ffcdd6f4, #b2262626, #ffffffff, #ffeeeeec, #ff89b4fa
  '';
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
            color_scheme_path = "${pkgs.writeText "style-colors.conf" style-colors}";
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
          inherit (pkgs.qt6ct) name pname version meta;
          paths = [pkgs.qt6ct];
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
