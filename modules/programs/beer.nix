{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.beer;
in
{
  options.cfg.programs.beer.enable = mkEnableOption "beer";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        inputs.beer.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      xdg.config.files = {
        "beer/beer.toml" = {
          generator = (pkgs.formats.toml { }).generate "beer.toml";
          value = {
            main = {
              font = "monospace";
              font-size = 17;
              pad-x = 8;
              pad-y = 8;
              subpixel = "none";
              hinting = "none";
            };
            colors = {
              alpha = 0.85;
            };
            cursor.style = "beam";
          };
        };
        "wallust/wallust.toml".value.templates.beer = mkIf config.cfg.programs.wallust.enable {
          target = "~/.config/beer/colors_beer.toml";
          template = (pkgs.formats.toml { }).generate "colors_beer.toml" {
            colors = {
              background = "{{background}}";
              foreground = "{{foreground}}";
              cursor = "{{cursor}}";

              selection-background = "{{foreground}}";
              selection-foreground = "{{background}}";

              regular = [
                "{{color0}}"
                "{{color1}}"
                "{{color2}}"
                "{{color3}}"
                "{{color4}}"
                "{{color5}}"
                "{{color6}}"
                "{{color7}}"
              ];

              bright = [
                "{{color8}}"
                "{{color9}}"
                "{{color10}}"
                "{{color11}}"
                "{{color12}}"
                "{{color13}}"
                "{{color14}}"
                "{{color15}}"
              ];
            };
          };
        };
      };
    };
    # include both the regular config and the wallust generated config
    environment.sessionVariables = mkIf config.cfg.programs.wallust.enable {
      BEER_CONFIG = "$XDG_CONFIG_HOME/beer/beer.toml:$XDG_CONFIG_HOME/beer/colors_beer.toml";
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "dev.notashelf.beer.desktop"
      ];
    };
  };
}
