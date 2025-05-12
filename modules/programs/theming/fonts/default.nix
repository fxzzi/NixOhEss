{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.cfg.gui.fontconfig;
in {
  options.cfg.gui.fontconfig = {
    enable = lib.mkEnableOption "fonts";
    useMonoEverywhere = lib.mkEnableOption "use mono everywhere";
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
