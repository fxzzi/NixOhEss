{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  apple-fonts = inputs.apple-fonts.packages.${pkgs.system};
in {
  options.cfg.gui.fontconfig = {
    enable = lib.mkEnableOption "";
    apple-fonts.enable = lib.mkEnableOption "apple-fonts";
    subpixelLayout = lib.mkOption {
      type = lib.types.enum [
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
  config = lib.mkIf config.cfg.gui.fontconfig.enable {
    fonts = {
      enableDefaultPackages = false;
      fontconfig = {
        subpixel.rgba = config.cfg.gui.fontconfig.subpixelLayout;
        # fixes emojis on browser
        useEmbeddedBitmaps = true;

        enable = true;
        defaultFonts = {
          serif = [
            (
              if config.cfg.gui.fontconfig.apple-fonts.enable
              then "New York Small"
              else "Noto Serif"
            )
          ];
          sansSerif = [
            (
              if config.cfg.gui.fontconfig.apple-fonts.enable
              then "SF Pro Text"
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

      packages = with pkgs;
        [
          nerd-fonts.symbols-only # symbols for terminal, bar, lock, etc
          noto-fonts # Google Noto Fonts
          noto-fonts-emoji # Emoji Font
          noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts
          corefonts # ms fonts.
          (pkgs.callPackage ./ioshelfka-term.nix {}) # custom iosevka build
        ]
        ++ lib.optionals (!config.cfg.gui.fontconfig.apple-fonts.enable) [
          inter
        ]
        ++ lib.optionals config.cfg.gui.fontconfig.apple-fonts.enable [
          apple-fonts.sf-pro
          apple-fonts.ny
        ];
    };
  };
}
