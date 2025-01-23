{
  inputs,
  lib,
  config,
  ...
}: {
  options.gui.ags.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables aylurs-gtk-shell and its configs.";
  };
  # add the home manager module
  imports = [inputs.ags.homeManagerModules.default];
  config = lib.mkIf config.gui.ags.enable {
    programs.ags = {
      enable = true;
      # null or path, leave as null if you don't want hm to manage the config
      configDir = null;
    };
    xdg.configFile = {
      "ags/icons".source = ./ags/icons;
      "ags/modules".source = ./ags/modules;
      "ags/config.js".source = ./ags/config.js;
      "ags/style.css".source = ./ags/style.css;
    };
  };
}
