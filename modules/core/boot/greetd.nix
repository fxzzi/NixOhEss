{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  hyprland =
    if config.cfg.gui.hypr.hyprland.useGit
    then inputs.hyprland.packages.${pkgs.system}.hyprland
    else pkgs.hyprland;
  hyprland-session = "${hyprland}/share/wayland-sessions";
  wrapper =
    if config.cfg.wayland.uwsm.enable
    then "--session-wrapper '${lib.getExe pkgs.uwsm} start -F --'"
    else "";
in {
  options.cfg.bootConfig.greetd.enable = lib.mkEnableOption "greetd";
  config = lib.mkIf config.cfg.bootConfig.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            # sh
            ''
              ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --greeting 'Welcome to the fold of NixOhEss.' \
              --time \
              --remember \
              --asterisks \
              ${wrapper} \
              --sessions ${hyprland-session}

            '';
          user = "greeter";
        };
      };
    };
    # this is a life saver.
    # literally no documentation about this anywhere.
    # might be good to write about this...
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
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
