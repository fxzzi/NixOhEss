{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.greetd;
  wrapper =
    if config.cfg.programs.uwsm.enable
    then "--session-wrapper '${getExe pkgs.uwsm} start -F --'"
    else "";
in {
  options.cfg.services.greetd.enable = mkEnableOption "greetd";
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command =
            # sh
            ''
              ${pkgs.tuigreet}/bin/tuigreet \
              --greeting 'Welcome to the fold of NixOhEss.' \
              --time \
              --remember \
              --asterisks \
              ${wrapper} \
              -c 'Hyprland'

            '';
          user = "greeter";
        };
      };
    };
  };
}
