{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.greetd;
in {
  options.cfg.services.greetd.enable = mkEnableOption "greetd";
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            # sh
            ''
              ${pkgs.tuigreet}/bin/tuigreet \
              --greeting 'Welcome to the fold of ${config.system.nixos.distroName}.' \
              --time \
              --remember \
              --asterisks
            '';
          user = "greeter";
        };
      };
    };
    # this is a life saver.
    # literally no documentation about this anywhere.
    # might be good to write about this...
    # https://www.old.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
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
