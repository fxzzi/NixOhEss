{
  lib,
  xLib,
  config,
  pkgs,
  user,
  npins,
  ...
}: let
  inherit (xLib.generators) toHyprlang;
in {
  options.cfg.gui.hypr.hyprpaper.enable = lib.mkEnableOption "hyprpaper";
  config = lib.mkIf config.cfg.gui.hypr.hyprpaper.enable {
    hj = {
      files = {
        ".local/share/walls".source = "${npins.walls}/images"; # wallpapers
      };

      packages = [pkgs.hyprpaper];
      files = {
        ".config/hypr/hyprpaper.conf".text = toHyprlang {} {
          ipc = 1;
          splash = 0;

          preload = [
            "/home/${user}/.local/state/wallpaper"
          ];
          wallpaper = [
            ", /home/${user}/.local/state/wallpaper"
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
        ExecStart = "${lib.getExe pkgs.hyprpaper}";
      };
    };
  };
}
