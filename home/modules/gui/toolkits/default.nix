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
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      font = {
        name = "SF Pro Text";
        size = 11;
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
        name = "tokyonight";
      };
    };
    home.pointerCursor = {
      gtk.enable = true;
      name = "XCursor-Pro-Light";
      size = 24;
      package = pkgs.xcursor-pro;
    };
		home.sessionVariables = {
			# so that it uses dark theme on gtk4 apps
			GTK_THEME = "${config.gtk.theme.name}:dark";
		};
  };
}
