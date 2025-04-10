{
  pkgs,
  config,
  lib,
  ...
}: {
  options.cfg.gui.wleave.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables wleave and its configs.";
  };
  config = lib.mkIf config.cfg.gui.wleave.enable {
    programs.wlogout = {
      package = pkgs.wleave;
      enable = true;
    };
    xdg.configFile = {
      "wleave/layout.json".source = (pkgs.formats.json {}).generate "wleave-layout" {
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
            action = "loginctl terminate-user ''";
            text = "Logout";
            keybind = "e";
          }
        ];
      };
      "wleave/style.css".text =
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
}
