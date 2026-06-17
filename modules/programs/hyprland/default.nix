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
      defaultMonitor = mkOption {
        type = types.str;
        default = "DP-1";
        description = "Sets the default monitor for hypr*";
      };
      secondaryMonitor = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Sets the secondary monitor for hypr*.";
      };
      extraHlConfig = mkOption {
        type = types.attrsOf types.anything;
        description = "Extra configuration for hl.config";
      };
      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Extra lua configuration for Hyprland";
      };
    };
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hyprlandSet.hyprland;
      portalPackage = hyprlandSet.xdg-desktop-portal-hyprland;
    };
    systemd.user = {
      # the document portal breaks itself when i log out and back in.
      # is it even needed outside of flatpaks?? mask it.
      services.xdg-document-portal.enable = false;
      # the nixos-fake-graphical-session is quite bare by default.
      # add some other attributes like listed here:
      # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#hyprland-sessiontarget
      targets.nixos-fake-graphical-session = {
        unitConfig = {
          Wants = "graphical-session-pre.target";
          After = "graphical-session-pre.target";
          PropagatesStopTo = "graphical-session.target";
        };
      };
    };
  };
}
