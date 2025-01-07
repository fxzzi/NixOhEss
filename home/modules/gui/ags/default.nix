{ pkgs, config, lib, ... }:
{
  options.gui.ags.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables aylurs-gtk-shell and its configs.";
  };
  config = lib.mkIf config.gui.ags.enable {
    home.packages = (with pkgs; [ ags ]);
    home.file = {
      ".config/ags/icons".source = ./config/icons;
      ".config/ags/modules".source = ./config/modules;
      ".config/ags/config.js".source = ./config/config.js;
      ".config/ags/style.css".source = ./config/style.css;
    };
  };
}
