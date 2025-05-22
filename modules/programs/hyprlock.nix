{
  lib,
  xLib,
  config,
  inputs,
  pkgs,
  user,
  ...
}: let
  # toHyprlang broken for now, use toHyprconf instead
  inherit (xLib.generators) toHyprconf;

  multiMonitor =
    if config.cfg.gui.hypr.secondaryMonitor != null
    then true
    else false;
  pkg =
    if config.cfg.gui.hypr.useGit
    then inputs.hyprlock.packages.${pkgs.system}
    else pkgs;
in {
  options.cfg.gui.hypr.hyprlock.enable = lib.mkEnableOption "hyprlock";
  config = lib.mkIf config.cfg.gui.hypr.hyprlock.enable {
    hj = {
      packages = [
        pkg.hyprlock
      ];
      files = {
        ".config/hypr/hyprlock.conf".text = toHyprconf {
          importantPrefixes = ["bezier"];
          attrs = {
            general = {
              hide_cursor = true;
              ignore_empty_input = true;
              immediate_render = !config.cfg.gui.hypr.animations.enable;
            };
            bezier = [
              "easeOut, 0.61, 1, 0.88, 1"
              "easeIn, 0.12, 0, 0.39, 0"
            ];
            animations = {
              enabled = config.cfg.gui.hypr.animations.enable;

              animation = [
                "fadeIn, 1, 3, easeIn"
                "fadeOut, 1, 3, easeOut"
              ];
            };
            background =
              [
                {
                  monitor = "${config.cfg.gui.hypr.defaultMonitor}";
                  path = "/home/${user}/.local/state/wallpaper";
                  blur_size = 3;
                  blur_passes = 3;
                  contrast = 1;
                  brightness = 0.5;
                  vibrancy = 0.5;
                }
              ]
              ++ lib.optional multiMonitor {
                monitor = "";
                path = "/home/${user}/.local/state/wallpaper";
                blur_size = 3;
                blur_passes = 3;
                contrast = 0.9;
                brightness = 0.3;
                vibrancy = 0.3;
              };
            input-field = [
              {
                monitor = "${config.cfg.gui.hypr.defaultMonitor}";
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
                monitor = "${config.cfg.gui.hypr.defaultMonitor}";
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
                monitor = "${config.cfg.gui.hypr.defaultMonitor}";
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
                monitor = "${config.cfg.gui.hypr.defaultMonitor}";
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
  };
}
