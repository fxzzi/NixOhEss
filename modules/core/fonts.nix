{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  config = {
    fonts = {
      enableDefaultPackages = false;
      packages = with pkgs; [
        nerd-fonts.lilex

        (google-fonts.override {
          fonts = [
            "Outfit"
          ];
        })

        # should provide fallbacks for pretty much every language
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

        corefonts # ms fonts
        vista-fonts # more ms fonts including calibri and consolas

      ];
      fontconfig = {
        subpixel = {
          rgba = mkDefault "rgb";
          # lcdfilter = "light";
        };
        includeUserConf = false;

        enable = true;
        defaultFonts = {
          sansSerif = [
            "Outfit"
          ];
          serif = [
            "Noto Serif"
          ];
          monospace = [
            "Lilex Nerd Font"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
      };
    };
  };
}
