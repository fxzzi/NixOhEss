{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  apple-fonts = inputs.apple-fonts.packages.${pkgs.system};
in {
  options.gui.fontConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables font configurations";
  };
  config = lib.mkIf config.gui.fontConfig.enable {
    home.packages = with pkgs; [
      nerd-fonts.space-mono
      noto-fonts # Google Noto Fonts
      noto-fonts-emoji # Emoji Font
      noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts
      # also grab apple fonts from flake
      apple-fonts.sf-pro
      apple-fonts.ny
      icomoon-feather
      corefonts # ms fonts.
    ];
    gtk = {
      font = {
        name = "SF Pro Text";
      };
    };
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "New York Medium"
        ];
        sansSerif = [
          "SF Pro Text"
        ];
        monospace = [
          "SpaceMono Nerd Font"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
