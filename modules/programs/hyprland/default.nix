{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf getExe';
  cfg = config.cfg.programs.hyprland;
  pkg =
    if cfg.useGit
    then inputs.hyprland.packages.${pkgs.system}
    else pkgs;
  uwsm = getExe' config.programs.uwsm.package "uwsm";
  uwsmEnabled = config.cfg.programs.uwsm.enable;
  autoStartCmd =
    if uwsmEnabled
    then ''
      if ${uwsm} check may-start; then
        exec ${uwsm} start -F -- Hyprland
      fi
    ''
    else ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec Hyprland
      fi
    '';
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
    inputs.hyprland.nixosModules.default
    ./env.nix
    ./settings.nix
    ./cursor.nix
  ];

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = pkg.hyprland;
      portalPackage = pkg.xdg-desktop-portal-hyprland;
      withUWSM = config.cfg.programs.uwsm.enable;
    };
    environment.loginShellInit = mkIf cfg.autoStart autoStartCmd;
  };
}
