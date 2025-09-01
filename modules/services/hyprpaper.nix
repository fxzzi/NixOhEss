{
  lib,
  xLib,
  pkgs,
  config,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.hyprpaper;
in {
  options.cfg.services.hyprpaper.enable = mkEnableOption "hyprpaper";
  config = mkIf cfg.enable {
    hj = {
      xdg.data.files."walls".source = "${npins.walls}/images"; # wallpapers

      packages = [pkgs.hyprpaper];
      xdg.config.files."hypr/hyprpaper.conf" = {
        generator = xLib.generators.toHyprlang {};
        value = {
          ipc = 1;
          splash = 0;

          preload = ["~/.local/state/wallpaper"];
          wallpaper = [",~/.local/state/wallpaper"];
        };
      };
    };
    systemd.user.services.hyprpaper = {
      enable = true;
      description = "Hyprpaper wallpaper manager";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${getExe pkgs.hyprpaper}";
      };
    };
  };
}
