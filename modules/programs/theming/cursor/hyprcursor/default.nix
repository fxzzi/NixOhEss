{
  lib,
  pkgs,
  config,
  ...
}: let
  cursor = config.cfg.gui.hypr.hyprcursor.theme;
in {
  options = {
    cfg.gui.hypr.hyprcursor.theme = lib.mkOption {
      type = lib.types.enum [
        "posy-cursors"
        "xcursor-pro"
      ];
      default = "xcursor-pro";
      description = ''
        The cursor theme to use for Hyprland.
        This is used to set the cursor theme in the environment.sessionVariables.
      '';
    };
  };
  config = lib.mkIf config.cfg.gui.hypr.hyprland.enable {
    environment.sessionVariables = {
      HYPRCURSOR_THEME = cursor;
      HYPRCURSOR_SIZE =
        if cursor == "posy-cursors"
        then 21 # posy hyprcursor is weird and is wrongly sized.
        else 24;
    };
    hj = {
      packages = [
        (pkgs.callPackage ./${cursor}-hyprcursor.nix {})
      ];
    };
  };
}
