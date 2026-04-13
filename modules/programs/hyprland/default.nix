{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.cfg.programs.hyprland;
  hyprlandSet =
    if cfg.useGit
    then inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}
    else pkgs;
in {
  options.cfg.programs = {
    hyprland = {
      enable = mkEnableOption "Hyprland";
      useGit = mkOption {
        type = types.bool;
        default = false;
        description = "Use Hyprland from the flake.";
      };
    };
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hyprlandSet.hyprland;
      portalPackage = hyprlandSet.xdg-desktop-portal-hyprland;
    };
    services.dbus.implementation = "broker";
  };
}
