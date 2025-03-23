{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  apple-fonts = inputs.apple-fonts.packages.${pkgs.system};
in {
  options.cfg.gui.fontConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables font configurations";
  };
  config = lib.mkIf config.cfg.gui.fontConfig.enable {
    home.packages = with pkgs; [
      # nerd-fonts.space-mono
      noto-fonts # Google Noto Fonts
      noto-fonts-emoji # Emoji Font
      noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts
      # also grab apple fonts from flake
      # apple-fonts.sf-pro
      # apple-fonts.ny
      icomoon-feather
      # corefonts # ms fonts.
      (pkgs.callPackage ./ioshelfka-term-nerd.nix {})
    ];
    gtk = {
      font = {
        name = "Noto Sans";
        size = 11;
      };
    };
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif =
          [
            "Noto Serif"
          ]
          ++ config.fonts.fontconfig.defaultFonts.emoji;
        sansSerif =
          [
            config.gtk.font.name
          ]
          ++ config.fonts.fontconfig.defaultFonts.emoji;
        monospace = [
          "Ioshelfka Term"
          "icomoon-feather"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
