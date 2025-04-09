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
          if cursor == "XCursor-Pro-Light"
          then 24
          else if cursor == "Posy_Cursor"
          then 21
          else throw "Invalid cursor theme: ${cursor}";
      };
      packages = [
        (pkgs.callPackage ./${cursor}.nix {
          inherit config;
        })
      ];
    };
  };
}
