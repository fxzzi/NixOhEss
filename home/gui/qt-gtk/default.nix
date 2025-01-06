{ pkgs, ... }:
{
  home.packages = with pkgs; [
    catppuccin-papirus-folders
    qt6ct
  ];
  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
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
    theme = {
      name = "TokyoNight";
    };
  };
  home.pointerCursor = {
    gtk.enable = true;
    name = "XCursor-Pro-Light";
    size = 24;
    package = pkgs.xcursor-pro;
  };
}
