{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.cfg.core.fonts;
in {
  options.cfg.core.fonts = {
    enable = mkEnableOption "fonts";
  };
  config = mkIf cfg.enable {
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
            "JetBrains Mono"
            "Symbols Nerd Font Mono"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
      };
      packages = with pkgs; [
        nerd-fonts.symbols-only # symbols for terminal, bar, lock, etc
        noto-fonts # Google Noto Fonts
        noto-fonts-color-emoji # Emoji Font
        noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts
        corefonts # ms fonts
        vista-fonts # more ms fonts including calibri and consolas
        inter
        jetbrains-mono
      ];
    };
  };
}
