{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.greetd;
  tuigreet = inputs.tuigreet.packages.${pkgs.stdenv.hostPlatform.system}.default;
  hyprland-session =
    pkgs.writers.writeDashBin "hyprland-session"
    # sh
    ''
      # launch hyprland without any stdout
      Hyprland >/dev/null 2>&1
      # we run this in hyprland on shutdown too, but if Hyprland
      # crashes it isn't able to. run it again here to be safe.
      systemctl --user stop nixos-fake-graphical-session.target
    '';
in {
  options.cfg.services.greetd.enable = mkEnableOption "greetd";
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session = {
        command = getExe tuigreet;
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
      power = {
        use_setsid = false;
        shutdown = "systemctl poweroff";
        reboot = "systemctl reboot";
      };
    };
  };
}
