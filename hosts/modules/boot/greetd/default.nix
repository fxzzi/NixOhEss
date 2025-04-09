{
  lib,
  config,
  pkgs,
  ...
}: let
  cmd =
    if config.cfg.wayland.uwsm.enable
    then "uwsm start hyprland-uwsm.desktop"
    else "Hyprland";
in {
  options.cfg.bootConfig.greetd.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the greetd display manager for login.";
  };
  config = lib.mkIf config.cfg.bootConfig.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --greeting 'Welcome to the fold of NixOhEss.' \
            --time \
            --remember \
            --asterisks \
            --cmd '${cmd}'
          '';
          user = "greeter";
        };
      };
    };

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
