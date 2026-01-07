{
  lib,
  self,
  inputs',
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

      packages = [inputs'.hyprpaper.packages.default];
      xdg.config.files."hypr/hyprpaper.conf" = {
        generator = self.lib.generators.toHyprlang {};
        value = {
          splash = 0;
          "wallpaper[]".path = "~/.local/state/wallpaper";
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
        ExecStart = "${getExe inputs'.hyprpaper.packages.default}";
      };
    };
  };
}
