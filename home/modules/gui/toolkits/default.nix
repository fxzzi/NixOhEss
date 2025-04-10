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
    systemd.user.sessionVariables = {
      # so that it uses dark theme on gtk4 apps
      GTK_THEME = "${config.gtk.theme.name}:dark";
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
    };
    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
    };
    xdg.configFile."qt6ct/qt6ct.conf".text = lib.generators.toINI {} {
      Appearance = {
        icon_theme = config.gtk.iconTheme.name;
        custom_palette = true;
        color_scheme_path = "${./qt6ct-tokyonight.conf}";
        standard_dialogs = "xdgdesktopportal";
        style = "Fusion";
      };
      Fonts = {
        fixed = ''"monospace,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
        general = ''"sans-serif,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"'';
      };
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
