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
        includeUserConf = false;

        enable = true;
        defaultFonts = {
          sansSerif = [
            "Outfit"
          ];
          serif = [
            "Space Grotesk"
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
        # it downloads the entire ~3gb archive, then unpacks :(
        (google-fonts.override {
          fonts = [
            "Outfit"
            "Space Grotesk"
          ];
        })

        ibm-plex
        noto-fonts-color-emoji

        corefonts # ms fonts
        vista-fonts # more ms fonts including calibri and consolas
      ];
    };
  };
}
