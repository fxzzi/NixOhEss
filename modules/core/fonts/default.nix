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
    useMonoEverywhere = mkEnableOption "use mono everywhere";
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
            (
              if cfg.useMonoEverywhere
              then "Ioshelfka Term"
              else "Noto Serif"
            )
          ];
          sansSerif = [
            (
              if cfg.useMonoEverywhere
              then "Ioshelfka Term"
              else "Inter Variable"
            )
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
        (pkgs.callPackage ./ioshelfka-term.nix {}) # custom iosevka build
      ];
    };
  };
}
