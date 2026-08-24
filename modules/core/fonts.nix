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
      fontconfig = {
        subpixel = {
          rgba = mkDefault "rgb";
          lcdfilter = "light";
        };
        hinting.style = "slight";
        antialias = true;
        includeUserConf = false;
        # fixes emojis on browser
        useEmbeddedBitmaps = true;

        enable = true;
        defaultFonts = {
          serif = [
            "Playfair Display"
          ];
          sansSerif = [
            "Outfit"
          ];
          monospace = [
            "BlexMono Nerd Font"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
      };
      packages = with pkgs; [
        nerd-fonts.blex-mono

        # i wish there was a nicer way to do this, currently
        # it downloads the entire 2.7gb archive, then unpacks :(
        (google-fonts.override {
          fonts = [
            "Playfair Display"
            "Outfit"
          ];
        })

        noto-fonts
        noto-fonts-color-emoji # Emoji Font
        noto-fonts-cjk-sans # extra language fonts

        corefonts # ms fonts
        vista-fonts # more ms fonts including calibri and consolas
      ];
    };
  };
}
