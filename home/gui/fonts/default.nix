{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    nerd-fonts.space-mono
    noto-fonts # Google Noto Fonts
    noto-fonts-emoji # Emoji Font
    noto-fonts-cjk-sans # Chinese, Japanese and Korean fonts
    # also grab apple fonts from flake
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro
    inputs.apple-fonts.packages.${pkgs.system}.ny
    icomoon-feather
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
        "New York"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "SF Pro Text"
        "Noto Color Emoji"
      ];
      monospace = [
        "SpaceMono Nerd Font"
        "icomoon-feather"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
