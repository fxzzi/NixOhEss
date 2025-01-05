{ pkgs, ... }:
{
  home.packages = with pkgs; [ catppuccin-papirus-folders ];
  qt = {
    enable = true;
    platformTheme.name = "adwaita-dark";
  };
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "macchiato";
        accent = "blue";
      };
    };
    cursorTheme = {
      name = "XCursor-Pro-Light";
      package = pkgs.xcursor-pro;
      size = 24;
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    name = "XCursor-Pro-Light";
    package = pkgs.xcursor-pro;
  };
}
