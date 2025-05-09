{
  pkgs,
  config,
  lib,
  ...
}: let
  logoutAction =
    if config.cfg.wayland.uwsm.enable
    then "uwsm stop"
    else "hyprctl dispatch exit";
in {
  options.cfg.gui.wleave.enable = lib.mkEnableOption "wleave";
  config = lib.mkIf config.cfg.gui.wleave.enable {
    hj = {
      packages = [
        pkgs.wleave
      ];
      files = {
        ".config/wleave/layout.json".source = (pkgs.formats.json {}).generate "wleave-layout" {
          buttons = [
            {
              label = "shutdown";
              action = "systemctl poweroff";
              text = "Shutdown";
              keybind = "s";
            }
            {
              label = "reboot";
              action = "systemctl reboot";
              text = "Reboot";
              keybind = "r";
            }
            {
              label = "lock";
              action = "loginctl lock-session";
              text = "Lock";
              keybind = "l";
            }
            {
              label = "suspend";
              action = "systemctl suspend";
              text = "Suspend";
              keybind = "u";
            }
            {
              label = "logout";
              action = "${logoutAction}";
              text = "Logout";
              keybind = "e";
            }
          ];
        };
        ".config/wleave/style.css".text =
          # css
          ''
            @import url("./colors_wleave.css");

            window {
            	font-family: monospace;
            	font-size: 20pt;
            	color: #c0caf5;
            	/* text */
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

            #lock {
            	background-image: url("${./icons/lock.png}");
            }

            #lock:focus {
            	background-image: url("${./icons/lock-hover.png}");
            }

            #logout {
            	background-image: url("${./icons/logout.png}");
            }

            #logout:focus {
            	background-image: url("${./icons/logout-hover.png}");
            }

            #suspend {
            	background-image: url("${./icons/sleep.png}");
            }

            #suspend:focus {
            	background-image: url("${./icons/sleep-hover.png}");
            }

            #shutdown {
            	background-image: url("${./icons/power.png}");
            }

            #shutdown:focus {
            	background-image: url("${./icons/power-hover.png}");
            }

            #reboot {
            	background-image: url("${./icons/restart.png}");
            }

            #reboot:focus {
            	background-image: url("${./icons/restart-hover.png}");
            }
          '';
      };
    };
  };
}
