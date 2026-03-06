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
            delay-command-ms = 0;
            buttons-per-row = "1/1";
            show-keybinds = true;
            margin-top = 360;
            margin-bottom = 360;

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
            	font-size: 20pt;
            	color: #c0caf5;
            	background-color: @background;
            }

            button {
            	border-radius: 10px;
            	background-repeat: no-repeat;
            	background-position: center;
            	background-size: 50%;
            	border: none;
            	background-color: transparent;
            	margin: 5px;
            	transition:
            		box-shadow 0.1s ease-in-out,
            		background-color 0.1s ease-in-out;
            }

            button:hover {
            	background-color: @color0;
            }

            button:focus {
            	background-color: @color1;
            	color: @foreground;
            }
          '';
      };
    };
  };
}
