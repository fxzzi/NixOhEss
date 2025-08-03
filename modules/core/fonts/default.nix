{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.cfg.core.fonts;
in {
  options.cfg.core.fonts = {
    enable = mkEnableOption "fonts";
    useMonoEverywhere = mkEnableOption "use mono everywhere";
    subpixelLayout = mkOption {
      type = types.enum [
        "rgb"
        "bgr"
        "vrgb"
        "vbgr"
        "none"
      ];
      default = "rgb";
      description = ''
        Subpixel rendering layout. This is used to configure the order of
        subpixels in the LCD screen. The default is rgb, which is the most
        common layout.
      '';
    };
  };
  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = false;
      fontconfig = {
        subpixel.rgba = cfg.subpixelLayout;
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
