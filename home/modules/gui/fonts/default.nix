{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  apple-fonts = inputs.apple-fonts.packages.${pkgs.system};
in {
  options.cfg.gui.fontConfig = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables font configurations";
    };
    apple-fonts.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Swaps the Serif and Sans-Serif fonts with... a different font.";
    };
  };
  config = lib.mkIf config.cfg.gui.fontConfig.enable {
    home.packages = with pkgs;
      [
        nerd-fonts.symbols-only # symbols for terminal, bar, lock, etc
        noto-fonts # Google Noto Fonts
        noto-fonts-emoji # Emoji Font
        noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts
        corefonts # ms fonts.
        (pkgs.callPackage ./ioshelfka-term.nix {}) # custom iosevka build
      ]
      ++ lib.optionals (!config.cfg.gui.fontConfig.apple-fonts.enable) [
        inter
      ]
      ++ lib.optionals config.cfg.gui.fontConfig.apple-fonts.enable [
        apple-fonts.sf-pro
        apple-fonts.ny
      ];
    gtk = {
      font = {
        name =
          if config.cfg.gui.fontConfig.apple-fonts.enable
          then "SF Pro Text"
          else "Inter Variable";
        size = 11;
      };
    };
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          (
            if config.cfg.gui.fontConfig.apple-fonts.enable
            then "New York Small"
            else "Noto Serif"
          )
        ];
        sansSerif = [
          config.gtk.font.name
        ];
        monospace = [
          "Ioshelfka Term"
          "Symbols Nerd Font"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
