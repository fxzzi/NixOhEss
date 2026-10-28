{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.wleave;
in
{
  options.cfg.programs.wleave.enable = mkEnableOption "wleave";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.wleave
      ];
      xdg.config.files = {
        "wleave/layout.json" = {
          generator = lib.generators.toJSON { };
          value = {
            no-version-info = true;
            buttons-per-row = "1/1"; # all buttons on one row
            button-aspect-ratio = "2/3"; # slightly rectangular buttons
            show-keybinds = true;
            margin = 0;

            buttons = [
              {
                label = "shutdown";
                action = "systemctl poweroff";
                text = "Shutdown";
                keybind = "s";
                icon = ./icons/power.png;
              }
              {
                label = "reboot";
                action = "systemctl reboot";
                text = "Reboot";
                keybind = "r";
                icon = ./icons/restart.png;
              }
              {
                label = "suspend";
                action = "systemctl suspend";
                text = "Suspend";
                keybind = "u";
                icon = ./icons/sleep.png;
              }
              {
                label = "logout";
                action = "hyprctl dispatch 'hl.dsp.exit()'";
                text = "Logout";
                keybind = "e";
                icon = ./icons/logout.png;
              }
            ];
          };
        };
        "wallust/wallust.toml".value.templates.wleave = mkIf config.cfg.programs.wallust.enable {
          target = "~/.config/wleave/colors_wleave.css";
          template = builtins.toFile "colors_wleave.css" ''
            @define-color cursor {{cursor}};
            @define-color background rgba({{background | rgb}},0.75);
            @define-color foreground {{foreground}};
            @define-color color0  {{color0 | darken(0.5) }};
            @define-color color1  {{color1 | lighten(0.3)}};
            @define-color color2  {{color2 }};
            @define-color color3  {{color3 }};
            @define-color color4  {{color4 | darken(0.5) }};
            @define-color color5  {{color5 }};
            @define-color color6  {{color6 }};
            @define-color color7  {{color7 }};
            @define-color color8  {{color8 }};
            @define-color color9  {{color9 }};
            @define-color color10 {{color10}};
            @define-color color11 {{color11}};
            @define-color color12 {{color12}};
            @define-color color13 {{color13}};
            @define-color color14 {{color14}};
            @define-color color15 {{color15}};
          '';
        };
        "wleave/style.css".text =
          # css
          ''
            @import url("./colors_wleave.css");

            window {
            	font-family: monospace;
            	font-size: 18pt;
            	color: #c0caf5;
            	background-color: @background;
            }

            button {
            	border-radius: 0px;
            	border: none;
            	background-color: transparent;
            	margin: 5px;
            }

            button:hover, button:focus {
            	background-color: @color0;
            	color: @foreground;
            }
          '';
      };
    };
  };
}
