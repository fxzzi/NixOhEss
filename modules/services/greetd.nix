{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.greetd;
  cmd = pkgs.writeShellScriptBin "greetd-hyprland" ''
    /run/current-system/sw/bin/Hyprland || systemctl --user stop hyprland-session.target
  '';
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
              --asterisks \
              --cmd '${getExe cmd}'
            '';
          user = "greeter";
        };
      };
    };
  };
}
