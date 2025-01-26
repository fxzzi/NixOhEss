{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.gui.hypr.hypridle.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables hypridle and its configs.";
  };
  options.gui.hypr.hypridle.suspendTimeout = lib.mkOption {
    type = lib.types.int;
    default = 360;
    description = "Sets the suspend timeout for hypridle.";
  };
  config = lib.mkIf config.gui.hypr.hypridle.enable {
    services.hypridle = {
      enable = true;
      package = inputs.hypridle.packages.${pkgs.system}.default;
      settings = {
        general = {
          lock_cmd = "pidof ${builtins.baseNameOf (lib.getExe inputs.hyprlock.packages.${pkgs.system}.default)} || (cp $(${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} hyprpaper listloaded) /tmp/wallpaper; ${lib.getExe inputs.hyprlock.packages.${pkgs.system}.default})";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 330;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = config.gui.hypr.hypridle.suspendTimeout;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
