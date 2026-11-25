{
  self,
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.hyprtoolkit;
in
{
  options.cfg.programs.hyprtoolkit.enable = mkEnableOption "hyprtoolkit theming" // {
    default = config.cfg.programs.hyprland.enable;
  };
  config = mkIf (cfg.enable && config.cfg.programs.wallust.enable) {
    hj.xdg.config.files."wallust/wallust.toml".value.templates.hyprtoolkit = {
      template = pkgs.writeText "hyprtoolkit.conf" (
        self.lib.generators.toHyprlang { } {
          background = "0xFF{{background | strip}}";
          base = "0xFF{{background | lighten(0.05) | strip}}";
          text = "0xFF{{foreground | strip}}";
          alternate_base = "0xFF{{color8 | strip}}";
          bright_text = "0xFF{{color15 | strip}}";
          accent = "0xFF{{color4 | strip}}";
          accent_secondary = "0xFF{{color6 | strip}}";

          rounding_large = 6;
          rounding_small = 4;
        }
      );
      target = "~/.config/hypr/hyprtoolkit.conf";
    };
  };
}
