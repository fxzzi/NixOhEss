{
  lib,
  xLib,
  pkgs,
  config,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  inherit (xLib.generators) toHyprlang;
  cfg = config.cfg.services.hyprpaper;
in {
  options.cfg.services.hyprpaper.enable = mkEnableOption "hyprpaper";
  config = mkIf cfg.enable {
    hj = {
      files = {
        ".local/share/walls".source = "${npins.walls}/images"; # wallpapers
      };

      packages = [pkgs.hyprpaper];
      files = {
        ".config/hypr/hyprpaper.conf".text = toHyprlang {} {
          ipc = 1;
          splash = 0;

          preload = ["~/.local/state/wallpaper"];
          wallpaper = [",~/.local/state/wallpaper"];
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
        ExecStart = "${getExe pkgs.hyprpaper}";
      };
    };
  };
}
