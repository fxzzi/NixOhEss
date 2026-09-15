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
            "IBM Plex Serif"
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
        ibm-plex
        nerd-fonts.blex-mono

        # i wish there was a nicer way to do this, currently
        # it downloads the entire ~3gb archive, then unpacks :(
        (google-fonts.override {
          fonts = [ "Outfit" ];
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
