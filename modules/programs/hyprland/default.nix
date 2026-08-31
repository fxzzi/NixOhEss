{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.cfg.programs.hyprland;
  hyprlandSet =
    if cfg.useGit then inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system} else pkgs;
in
{
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
      portalPackage = hyprlandSet.xdg-desktop-portal-hyprland.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          # revert a commit which stops dmabuf screencopy from working.
          # it makes it fall back to slow SHM every time. revert it for now
          ./0001-Revert-screencopy-add-DMA-BUF-to-SHM-fallback-379.patch
        ];
      });
    };
  };
}
