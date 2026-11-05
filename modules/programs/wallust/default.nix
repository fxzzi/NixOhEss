{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.wallust;
in
{
  options.cfg.programs.wallust.enable = mkEnableOption "wallust";
  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        wallust
      ];
      xdg.config.files = {
        "wallust/wallust.toml" = {
          generator = (pkgs.formats.toml { }).generate "wallust.toml";
          value = {
            check_contrast = true;
            # normally sends OSC terminal sequences to set colors.
            # instead, just reload the terminal config, in our case beer.
            skip_sequences = true;
            backend = "fastresize";
            color_space = "lch";
            templates = {
              # contains one hex of the accent colour of current theme.
              # currently used in screenshot script for the border colour.
              # may be used for other things later.
              accent = {
                template = ./templates/accent.txt;
                target = "~/.cache/wallust/accent.txt";
              };
            };
          };
        };
      };
    };
  };
}
