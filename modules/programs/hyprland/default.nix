{
  lib,
  pkgs,
  config,
  inputs,
  self,
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
      portalPackage = hyprlandSet.xdg-desktop-portal-hyprland;
    };
    hj.xdg.config.files."wallust/wallust.toml".value.templates.hyprtoolkit =
      mkIf config.cfg.programs.wallust.enable
        {
          template = builtins.toFile "hyprtoolkit.conf" (
            self.lib.generators.toHyprlang { } {
              background = "0xFF{{background | strip}}";
              base = "0xFF{{color0 | strip}}";
              text = "0xFF{{foreground | strip}}";
              alternate_base = "0xFF{{color8 | strip}}";
              bright_text = "0xFF{{color15 | strip}}";
              accent = "0xFF{{color2 | strip}}";
              accent_secondary = "0xFF{{color4 | strip}}";

              rounding_large = 4;
              rounding_small = 2;
            }
          );
          target = "~/.config/hypr/hyprtoolkit.conf";
        };
  };
}
