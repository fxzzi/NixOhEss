{
  lib,
  xLib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optional;
  # toHyprlang broken for now, use toHyprconf instead
  inherit (xLib.generators) toHyprconf;
  cfg = config.cfg.programs.hyprlock;
  multiMonitor =
    if config.cfg.programs.hyprland.secondaryMonitor != null
    then true
    else false;
in {
  options.cfg.programs.hyprlock.enable = mkEnableOption "hyprlock";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.hyprlock
      ];
      xdg.config.files."hypr/hyprlock.conf".text = toHyprconf {
        importantPrefixes = ["bezier"];
        attrs = {
          general = {
            hide_cursor = true;
            ignore_empty_input = true;
            immediate_render = !config.cfg.programs.hyprland.animations.enable;
          };
          bezier = [
            "easeOut, 0.61, 1, 0.88, 1"
            "easeIn, 0.12, 0, 0.39, 0"
          ];
          animations = {
            enabled = config.cfg.programs.hyprland.animations.enable;

            animation = [
              "fadeIn, 1, 3, easeIn"
              "fadeOut, 1, 3, easeOut"
            ];
          };
          background =
            [
              {
                monitor = "${config.cfg.programs.hyprland.defaultMonitor}";
                path = "/home/${config.cfg.core.username}/.local/state/wallpaper";
                blur_size = 3;
                blur_passes = 3;
                contrast = 1;
                brightness = 0.5;
                vibrancy = 0.5;
              }
            ]
            ++ optional multiMonitor {
              monitor = "";
              path = "/home/${config.cfg.core.username}/.local/state/wallpaper";
              blur_size = 3;
              blur_passes = 3;
              contrast = 0.9;
              brightness = 0.3;
              vibrancy = 0.3;
            };
          input-field = [
            {
              monitor = "${config.cfg.programs.hyprland.defaultMonitor}";
              size = "350, 45";
              outline_thickness = 2;
              dots_size = 0.25; # Scale of input-field height, 0.2 - 0.8
              dots_spacing = 0.66; # Scale of dots' absolute size, 0.0 - 1.0
              dots_center = true;
              outer_color = "0xff1a1b26";
              inner_color = "0xff1a1b26";
              font_color = "0xffc8d3f6";
              placeholder_text = ''<span font="monospace"><i>Password...</i></span>''; # Text rendered when empty
              fail_text = ''<span font="monospace"><i>Incorrect.</i></span>'';
              hide_input = false;
              position = "0, 120";
              halign = "center";
              valign = "bottom";
            }
          ];

          label = [
            {
              monitor = "${config.cfg.programs.hyprland.defaultMonitor}";
              text = ''cmd[update:1000] echo "$(date +"%H:%M:%S")"'';
              color = "0xffc8d3f5";
              font_size = 72;
              font_family = "monospace Bold";
              shadow_passes = 2;
              shadow_size = 2;
              position = "0, 40";
              halign = "center";
              valign = "center";
            }
            {
              monitor = "${config.cfg.programs.hyprland.defaultMonitor}";
              text = ''cmd[update:18000000] echo "$(date +'%A, %-d %B')"'';
              color = "0xffc8d3f5";
              font_size = 24;
              font_family = "monospace Bold";
              shadow_passes = 2;
              shadow_size = 2;
              position = "0, -40";
              halign = "center";
              valign = "center";
            }
            {
              monitor = "${config.cfg.programs.hyprland.defaultMonitor}";
              text = "󰌾";
              color = "0xffc8d3f5";
              font_size = 36;
              font_family = "monospace";
              shadow_passes = 2;
              shadow_size = 2;
              position = "0, 40";
              halign = "center";
              valign = "bottom";
            }
          ];
        };
      };
    };
  };
}
