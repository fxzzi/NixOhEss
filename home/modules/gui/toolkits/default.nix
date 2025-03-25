{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options.cfg.gui.toolkitConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables toolkit (qt and gtk) configurations.";
  };
  config = lib.mkIf config.cfg.gui.toolkitConfig.enable {
    # source gtk theme from tokyo-night-linux github
    xdg.dataFile = {
      "themes/tokyonight" = {
        source = "${inputs.tokyo-night-linux}/usr/share/themes/TokyoNight";
      };
    };
    home = {
      packages = with pkgs; [
        qt6ct
      ];
      pointerCursor = {
        dotIcons.enable = false; # stop creation of .icons dir
        gtk.enable = true;
        name = "XCursor-Pro-Light";
        size = 24;
        package = pkgs.xcursor-pro;
      };
      sessionVariables = {
        # so that it uses dark theme on gtk4 apps
        GTK_THEME = "${config.gtk.theme.name}:dark";
      };
    };
    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
    };
    gtk = {
      enable = true;
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "macchiato";
          accent = "blue";
        };
      };
      cursorTheme = {
        inherit (config.home.pointerCursor) name;
        inherit (config.home.pointerCursor) package;
        inherit (config.home.pointerCursor) size;
      };
      theme = {
        name = "tokyonight";
      };
    };
  };
}
