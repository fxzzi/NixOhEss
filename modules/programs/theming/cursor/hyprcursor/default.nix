{
  lib,
  pkgs,
  config,
  ...
}: let
  cursor = config.cfg.gui.hypr.hyprcursor.theme;
  hyprcursorPkg =
    if cursor == "posy-cursors"
    then ./posy-cursors-hyprcursor.nix
    else if cursor == "xcursor-pro"
    then ./xcursor-pro-hyprcursor.nix
    else if cursor == "bibata-hyprcursor"
    then ./bibata-hyprcursor/default.nix
    else throw "unknown cursor theme";
  hyprcursorName =
    if cursor == "bibata-hyprcursor"
    then "Bibata-original"
    else cursor;
in {
  options = {
    cfg.gui.hypr.hyprcursor.theme = lib.mkOption {
      type = lib.types.enum [
        "posy-cursors"
        "xcursor-pro"
        "bibata-hyprcursor"
      ];
      default = "bibata-hyprcursor";
      description = ''
        The cursor theme to use for Hyprland.
        This is used to set the cursor theme in the environment.sessionVariables.
      '';
    };
  };
  config = lib.mkIf config.cfg.gui.hypr.hyprland.enable {
    environment.sessionVariables = {
      HYPRCURSOR_THEME = hyprcursorName;
      HYPRCURSOR_SIZE =
        if cursor == "posy-cursors"
        then 21 # posy hyprcursor is weird and is wrongly sized.
        else 24;
    };
    hj = {
      packages = [
        (pkgs.callPackage hyprcursorPkg {})
      ];
    };
  };
}
