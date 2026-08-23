{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.greetd;
  hyprland-session =
    pkgs.writers.writeDashBin "hyprland-session"
    # sh
    ''
      # launch hyprland without any stdout
      Hyprland >/dev/null 2>&1
      # hyprland runs this automatically on shut-down.
      # but it can't if it crashes. so run it here.
      if systemctl --user is-active --quiet graphical-session.target; then
          systemctl --user stop graphical-session.target
      fi
    '';
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
      session.command = getExe hyprland-session;
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
