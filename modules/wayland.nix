{ pkgs, ... }:

{
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-media-tags-plugin ]; # Enable some plugins for archive support
  };

  programs.file-roller.enable = true; # Enable File Roller for GUI archive management

  environment.systemPackages = with pkgs; [
    dunst
    libcanberra-gtk3
    papirus-icon-theme
    wl-clipboard
    mate.mate-polkit
    xdg-utils
    glib
    grim
    slurp
    wleave
    wallust
    ags
    hyprpaper
    hyprsunset
    hyprlock
    hypridle
    fuzzel
    pywalfox-native
    kdePackages.qt6ct
    cmake
    meson
    cpio
    pkg-config
  ];
}
