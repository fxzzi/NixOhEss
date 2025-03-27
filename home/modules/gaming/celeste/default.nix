{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  nixpkgs-olympus = inputs.nixpkgs-olympus.legacyPackages.${pkgs.system};
in {
  options.cfg.gaming.celeste = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Adds a .desktop file to run Celeste.";
    };
    modding.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Olympus";
    };
    path = lib.mkOption {
      type = lib.types.str;
      default = "games/celeste";
      description = "Relative path to Celeste game files inside the user's home directory.";
    };
  };

  config = lib.mkIf config.cfg.gaming.celeste.enable {
    home.packages = with pkgs; [
      (lib.mkIf config.cfg.gaming.celeste.modding.enable nixpkgs-olympus.olympus)
    ];

    xdg.desktopEntries.celeste = {
      name = "Celeste";
      comment = "Run Celeste";
      exec = "env FNA3D_FORCE_DRIVER=Vulkan SDL_VIDEODRIVER=wayland ${lib.getExe pkgs.steam-run} ${config.home.homeDirectory}/${config.cfg.gaming.celeste.path}/Celeste";
      icon = "${config.home.homeDirectory}/${config.cfg.gaming.celeste.path}/Celeste.png";
      terminal = false;
      type = "Application";
      categories = ["Game"];
    };
  };
}
