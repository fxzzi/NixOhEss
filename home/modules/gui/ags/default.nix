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
  imports = [inputs.ags.homeManagerModules.default];
  config = lib.mkIf config.gui.ags.enable {
    # add the home manager module
    programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      configDir = null;
    };
    xdg.configFile = {
      "ags/icons".source = ./config/icons;
      "ags/modules".source = ./config/modules;
      "ags/config.js".source = ./config/config.js;
      "ags/style.css".source = ./config/style.css;
    };
  };
}
