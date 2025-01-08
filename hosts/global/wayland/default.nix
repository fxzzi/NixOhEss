{ inputs, pkgs, ... }:

{
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
    ]; # Enable some plugins for archive support
  };

  programs.file-roller.enable = true; # Enable File Roller for GUI archive management

  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
		portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
}
