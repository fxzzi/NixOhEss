{
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  desktopEntry = pkgs.makeDesktopItem {
    desktopName = "Celeste";
    name = "celeste";
    comment = "Run Celeste";
    exec = "env FNA3D_FORCE_DRIVER=Vulkan SDL_VIDEODRIVER=wayland ${lib.getExe pkgs.steam-run} /home/${user}/${config.cfg.gaming.celeste.path}/Celeste";
    icon = "celeste";
    terminal = false;
    type = "Application";
    categories = ["Game"];
  };
in {
  options.cfg.gaming.celeste = {
    enable = lib.mkEnableOption "celeste";
    modding.enable = lib.mkEnableOption "modding";
    path = lib.mkOption {
      type = lib.types.str;
      default = "games/celeste";
      description = "Relative path to Celeste game files inside the user's home directory.";
    };
  };

  config = {
    hj = {
      packages = [
        (lib.mkIf config.cfg.gaming.celeste.modding.enable pkgs.olympus)
        (lib.mkIf config.cfg.gaming.celeste.enable desktopEntry)
      ];
    };
  };
}
