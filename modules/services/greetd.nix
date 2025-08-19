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
      useTextGreeter = true;
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
  };
}
