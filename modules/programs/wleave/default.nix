{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.wleave;
in {
  options.cfg.programs.wleave.enable = mkEnableOption "wleave";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.wleave
      ];
      xdg.config.files = {
        "wleave/layout.json" = {
          generator = lib.generators.toJSON {};
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
                action = "hyprctl dispatch exit";
                text = "Logout";
                keybind = "e";
                icon = ./icons/logout.png;
              }
            ];
          };
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
