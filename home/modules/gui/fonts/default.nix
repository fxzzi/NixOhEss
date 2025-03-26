{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  ioshelfka = inputs.ioshelfka.packages.${pkgs.system};
in {
  options.cfg.gui.fontConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables font configurations";
  };
  config = lib.mkIf config.cfg.gui.fontConfig.enable {
    home.packages = with pkgs; [
      inter # UI font
      nerd-fonts.symbols-only # symbols for terminal, bar, lock, etc
      noto-fonts # Google Noto Fonts
      noto-fonts-emoji # Emoji Font
      noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts
      corefonts # ms fonts.
      ioshelfka.ioshelfka-term
    ];
    gtk = {
      font = {
        name = "Inter Variable";
        size = 11;
      };
    };
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Noto Serif"
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
