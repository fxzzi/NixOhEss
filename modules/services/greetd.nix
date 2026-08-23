{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.greetd;
in {
  options.cfg.services.greetd.enable = mkEnableOption "greetd";
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session = {
        command = getExe pkgs.tuigreet;
        user = "greeter";
      };
    };
    environment.etc."tuigreet/config.toml".source = (pkgs.formats.toml {}).generate "tuigreet-config.toml" {
      display = {
        greeting = "Welcome to the fold of ${config.system.nixos.distroName}.";
        show_time = true;
        show_title = false;
        battery = true;
      };
      layout = {
        window_padding = 1;
        widgets = {
          time_position = "top";
          status_position = "bottom";
          status_bar = {
            show_reset = false;
            show_command = false;
            show_session = false;
            show_session_status = false;
            show_background = false;
          };
        };
      };
      session.command = "Hyprland >/dev/null 2>&1";
      secret = {
        mode = "characters";
        characters = "*";
      };
      remember = {
        default_user = config.cfg.core.username;
        username = true;
      };
      power = {
        use_setsid = false;
        shutdown = "systemctl poweroff";
        reboot = "systemctl reboot";
        suspend = "systemctl suspend";
        # no hibernate smh
        hibernate = "";
      };
    };
  };
}
