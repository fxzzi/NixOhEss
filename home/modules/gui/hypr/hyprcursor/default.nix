{
  lib,
  pkgs,
  config,
  ...
}: let
  cursor = config.cfg.gui.toolkitConfig.cursorTheme;
in {
  config = lib.mkIf config.cfg.gui.hypr.hyprland.enable {
    home = {
      pointerCursor = {
        hyprcursor.enable = true;
        hyprcursor.size =
          if cursor == "Posy_Cursor"
          then 21 # posy hyprcursor is weird and is wrongly sized.
          else 24;
      };
      packages = [
        (pkgs.callPackage ./${cursor}.nix {
          inherit config;
        })
      ];
    };
  };
}
