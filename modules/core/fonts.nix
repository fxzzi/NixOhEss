{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
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
            "Noto Serif"
          ];
          sansSerif = [
            "Inter"
          ];
          monospace = [
            # "JetBrainsMono Nerd Font"
            "JetBrains Mono"
            "Symbols Nerd Font"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
      };
      packages = with pkgs; [
        nerd-fonts.symbols-only
        jetbrains-mono
        nerd-fonts.jetbrains-mono

        inter

        noto-fonts # Google Noto Fonts
        noto-fonts-color-emoji # Emoji Font
        noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts

        corefonts # ms fonts
        vista-fonts # more ms fonts including calibri and consolas
      ];
    };
  };
}
