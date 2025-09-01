{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.cfg.programs.hyprland;
  autoStartCmd = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      Hyprland || systemctl --user stop hyprland-session.target
      exit
    fi
  '';
  hyprlandSet =
    if cfg.useGit
    then inputs.hyprland.packages.${pkgs.system}
    else pkgs;
in {
  options.cfg.programs = {
    hyprland = {
      enable = mkEnableOption "Hyprland";
      autoStart = mkOption {
        type = types.bool;
        default = false;
        description = "Enables hyprland to run automatically in tty1 (zsh)";
      };
      useGit = mkOption {
        type = types.bool;
        default = false;
        description = "Use Hyprland from the flake.";
      };
    };
  };
  imports = [
    ./env.nix
    ./settings.nix
    ./cursor.nix
  ];

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hyprlandSet.hyprland;
      portalPackage = hyprlandSet.xdg-desktop-portal-hyprland;
    };
    hj.xdg.config.files."zsh/.zprofile".text = mkIf cfg.autoStart autoStartCmd;
    services.dbus.implementation = "broker";
    systemd.user.targets.hyprland-session = {
      description = "Hyprland compositor session";
      documentation = ["man:systemd.special(7)"];
      bindsTo = ["graphical-session.target"];
      wants = [
        "graphical-session-pre.target"
      ];
      after = ["graphical-session-pre.target"];
    };
  };
}
