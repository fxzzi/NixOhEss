{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options.gui.ags.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables aylurs-gtk-shell and its configs.";
  };
  imports = [inputs.ags.homeManagerModules.default];
  config = lib.mkIf config.gui.ags.enable {
    # add the home manager module

    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      configDir = null;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
        upower
      ];
    };
    home.file = {
      ".config/ags/icons".source = ./config/icons;
      ".config/ags/modules".source = ./config/modules;
      ".config/ags/config.js".source = ./config/config.js;
      ".config/ags/style.css".source = ./config/style.css;
    };
  };
}
