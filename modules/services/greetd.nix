{
  lib,
  config,
  pkgs,
  pins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.cfg.services.greetd;
  tuigreet = pkgs.callPackage "${pins.tuigreet}/nix/package.nix" {};
  cmd = pkgs.writeShellScriptBin "greetd-hyprland" ''
    Hyprland
    systemctl --user stop hyprland-session.target
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
      };
      layout = {
        window_padding = 1;
        widgets = {
          time_position = "top";
          status_position = "hidden";
        };
      };
      # silence cmd output also
      session.command = "${getExe cmd} >/dev/null 2>&1";
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
