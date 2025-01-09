{
  pkgs,
  lib,
  config,
  ...
}: {
  options.gui.toolkitConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables toolkit (qt and gtk) configurations.";
  };
  config = lib.mkIf config.gui.toolkitConfig.enable {
    home.packages = with pkgs; [
      qt6ct
    ];
    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
    };
    gtk = {
      enable = true;
      font = {
        name = "SF Pro Text";
        size = 11.5;
      };
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
  };
}
