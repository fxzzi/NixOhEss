{
  lib,
  self,
  pkgs,
  config,
  pins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.hyprpaper;
in {
  options.cfg.services.hyprpaper.enable = mkEnableOption "hyprpaper";
  config = mkIf cfg.enable {
    hj = {
      xdg.data.files."walls".source = "${pins.walls}/images"; # wallpapers

      packages = [pkgs.hyprpaper];
      xdg.config.files."hypr/hyprpaper.conf" = {
        generator = self.lib.generators.toHyprlang {};
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
