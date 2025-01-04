#!/usr/bin/env sh

# # Set the GTK theme to TokyoNight
# gsettings set org.gnome.desktop.interface gtk-theme TokyoNight
#
# # Set the icon theme to Papirus-Dark
# gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
#
# # Set the cursor theme and size
# gsettings set org.gnome.desktop.interface cursor-theme XCursor-Pro-Light
# gsettings set org.gnome.desktop.interface cursor-size 24

# Set the GTK theme to TokyoNight
dconf write /org/gnome/desktop/interface/gtk-theme "'TokyoNight'"

# Set the icon theme to Papirus-Dark
dconf write /org/gnome/desktop/interface/icon-theme "'Papirus-Dark'"

# Set the cursor theme and size
dconf write /org/gnome/desktop/interface/cursor-theme "'XCursor-Pro-Light'"
dconf write /org/gnome/desktop/interface/cursor-size 24
