{ config, pkgs, ... }: 
{
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "SpaceMono" ]; }) # Only install specific Nerd Font, no others
    noto-fonts # Google Noto Fonts
    noto-fonts-emoji # Emoji Font
    noto-fonts-cjk # Chinese, Japanese and Korean fonts
  ];
}
