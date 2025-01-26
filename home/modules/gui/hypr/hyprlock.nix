{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  multiMonitor =
    if config.gui.hypr.secondaryMonitor != null
    then true
    else false;
in {
  options.gui.hypr.hyprlock.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable hyprlock";
  };
  config = lib.mkIf config.gui.hypr.hyprlock.enable {
    programs.hyprlock = {
      enable = true;
      package = inputs.hyprlock.packages.${pkgs.system}.default;
      settings = {
        general = {
          hide_cursor = true;
          disable_loading_bar = true;
          immediate_render = true;
          ignore_empty_input = true;
        };
        animations = {
          enabled = false;
        };
        background = lib.mkMerge [
          [
            {
              monitor = "${config.gui.hypr.defaultMonitor}";
              path = "/tmp/wallpaper";
              blur_size = 3;
              blur_passes = 3; # 0 disables blurring
              contrast = 1;
              brightness = 0.5;
              vibrancy = 0.5;
            }
          ]
          (lib.mkIf multiMonitor [
            {
              monitor = "";
              path = "/tmp/wallpaper";
              blur_size = 3;
              blur_passes = 3; # 0 disables blurring
              contrast = 0.9;
              brightness = 0.3;
              vibrancy = 0.3;
            }
          ])
        ];

        input-field = [
          {
            monitor = "${config.gui.hypr.defaultMonitor}";
            size = "350, 45";
            outline_thickness = 2;
            dots_size = 0.25; # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.66; # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = true;
            outer_color = "0xff1a1b26";
            inner_color = "0xff1a1b26";
            font_color = "0xffc8d3f6";
            placeholder_text = ''<span font="SpaceMono Nerd Font"><i>Password...</i></span>''; # Text rendered when empty
            fail_text = ''<span font="SpaceMono Nerd Font"><i>Incorrect.</i></span>'';
            hide_input = false;
            position = "0, 120";
            halign = "center";
            valign = "bottom";
          }
        ];

        label = [
          {
            monitor = "${config.gui.hypr.defaultMonitor}";
            text = ''cmd[update:1000] echo "$(date +"%H:%M:%S")"'';
            color = "0xffc8d3f5";
            font_size = 72;
            font_family = "SpaceMono Nerd Font Bold";
            shadow_passes = 2;
            shadow_size = 2;
            position = "0, 40";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "${config.gui.hypr.defaultMonitor}";
            text = ''cmd[update:18000000] echo "$(date +'%A, %-d %B')"'';
            color = "0xffc8d3f5";
            font_size = 24;
            font_family = "SpaceMono Nerd Font Bold";
            shadow_passes = 2;
            shadow_size = 2;
            position = "0, -40";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "${config.gui.hypr.defaultMonitor}";
            text = "";
            color = "0xffc8d3f5";
            font_size = 36;
            font_family = "icomoon-feather";
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
}
