{
  lib,
  lib',
  config,
  inputs,
  pkgs,
  user,
  ...
}: let
  inherit (lib'.generators) toHyprlang;
  pkg =
    if config.cfg.gui.hypr.useGit
    then inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}
    else pkgs;
in {
  options.cfg.gui.hypr.hyprpaper.enable = lib.mkEnableOption "hyprpaper";
  config = lib.mkIf config.cfg.gui.hypr.hyprpaper.enable {
    hj = {
      files = {
        ".local/share/walls".source = "${inputs.walls}/images"; # wallpapers
      };

      packages = [pkg.hyprpaper];
      files = {
        ".config/hypr/hyprpaper.conf".text = toHyprlang {} {
          ipc = 1;
          splash = 0;

          preload = [
            "${config.hj.xdg.stateDirectory}/wallpaper"
          ];
          wallpaper = [
            ", ${config.hj.xdg.stateDirectory}/wallpaper"
          ];
        };
      };
    };
    systemd.user.services.hyprpaper = {
      enable = true;
      description = "hyprpaper wallpaper manager";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY"; # Only start if WAYLAND_DISPLAY env var is set
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${lib.getExe pkg.hyprpaper}";
      };
    };
  };
}
