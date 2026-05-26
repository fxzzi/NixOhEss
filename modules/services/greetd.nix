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
  hyprland-session = pkgs.writeShellApplication {
    name = "hyprland-session";
    runtimeInputs = [
      config.programs.hyprland.package
      config.services.dbus.dbusPackage
    ];
    text = ''
      # Make sure there's no already running session.
      if systemctl --user -q is-active hyprland.service; then
        echo 'A Hyprland session is already running.'
        exit 1
      fi

      # Reset failed state of all user units.
      systemctl --user reset-failed

      # DBus activation environment is independent from systemd. While most of
      # dbus-activated services are already using `SystemdService` directive, some
      # still don't and thus we should set the dbus environment with a separate
      # command.
      dbus-update-activation-environment --all --systemd

      # Start Hyprland and wait for it to terminate.
      # `|| true` here because Hyprland may crash and we want the script to continue.
      systemctl --user --wait start hyprland.service || true

      # Force stop of graphical-session.target.
      systemctl --user start --job-mode=replace-irreversibly hyprland-shutdown.target
    '';
  };
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
      };
      layout = {
        window_padding = 1;
        widgets = {
          time_position = "top";
          status_position = "hidden";
        };
      };
      # silence cmd output also
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
      };
    };
  };
}
