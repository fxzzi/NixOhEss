{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf getExe';
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
      config = mkOption {
        type = types.attrsOf types.anything;
        internal = true;
        description = "Base hl.config table rendered into hyprland.lua.";
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
    hj.systemd = {
      services = {
        hyprland = {
          unitConfig = {
            Description = "An independent, highly customizable, dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
            BindsTo = "graphical-session.target";
            Before = [
              "graphical-session.target"
              "xdg-desktop-autostart.target"
            ];
            Wants = [
              "graphical-session-pre.target"
              "xdg-desktop-autostart.target"
            ];
            After = "graphical-session-pre.target";
          };
          serviceConfig = {
            Slice = "session.slice";
            Type = "notify";
            ExecStart = getExe' hyprlandSet.hyprland "Hyprland";
          };
          # by default, nix sets path for the systemd service, which clears the default one.
          # this means that pretty much nothing works LOL, so disable this behaviour
          enableDefaultPath = false;
        };
      };
      targets = {
        hyprland-shutdown = {
          unitConfig = {
            Description = "Shutdown running Hyprland session";
            DefaultDependencies = "no";
            StopWhenUnneeded = "true";
            Conflicts = [
              "graphical-session.target"
              "graphical-session-pre.target"
            ];
            After = [
              "graphical-session.target"
              "graphical-session-pre.target"
            ];
          };
        };
      };
    };
  };
}
