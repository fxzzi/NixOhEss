{ pkgs, ... }:
{
  home.packages = (with pkgs; [ ags ]);
  home.file = {
    ".config/ags/icons".source = ./config/icons;
    ".config/ags/modules".source = ./config/modules;
    ".config/ags/config.js".source = ./config/config.js;
    ".config/ags/style.css".source = ./config/style.css;
  };
}
