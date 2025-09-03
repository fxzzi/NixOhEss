{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkDefault mkIf;
  cfg = config.cfg.core.fonts;
in {
  options.cfg.core.fonts = {
    enable = mkEnableOption "fonts";
  };
  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = false;
      fontconfig = {
        subpixel.rgba = mkDefault "rgb";
        includeUserConf = false;
        # fixes emojis on browser
        useEmbeddedBitmaps = true;

        enable = true;
        defaultFonts = {
          serif = [
            "Noto Serif"
          ];
          sansSerif = [
            "Inter Variable"
          ];
          monospace = [
            "Ioshelfka Term"
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
        noto-fonts-emoji # Emoji Font
        noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts
        corefonts # ms fonts.
        inter
        customPkgs.ioshelfka-term
      ];
    };
  };
}
