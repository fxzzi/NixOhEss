{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cursor = config.cfg.gui.toolkitConfig.cursorTheme;
in {
  options.cfg.gui.toolkitConfig.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables toolkit (qt and gtk) configurations.";
  };
  options.cfg.gui.toolkitConfig.cursorTheme = lib.mkOption {
    type = lib.types.enum [
      "XCursor-Pro-Light"
      "Posy_Cursor"
    ];
    default = "XCursor-Pro-Light";
    description = "Choose your cursor theme.";
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
        name = cursor;
        size = 24;
        package =
          if cursor == "XCursor-Pro-Light"
          then pkgs.xcursor-pro
          else if cursor == "Posy_Cursor"
          then pkgs.posy-cursors
          else throw "Invalid cursor theme: ${cursor}";
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
