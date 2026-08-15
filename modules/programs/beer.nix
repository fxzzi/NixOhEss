{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.beer;
in {
  options.cfg.programs.beer.enable = mkEnableOption "beer";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        # inputs.beer.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      xdg.config.files = {
        "beer/beer.toml" = {
          generator = (pkgs.formats.toml {}).generate "beer.toml";
          value = {
            main = {
              font = "monospace";
              pad-x = 6;
              pad-y = 6;
              # term = "xterm-256color";
              # subpixel = "none";
              # hinting = "none";
            };
            colors = {
              alpha = 0.85;
            };
            cursor.style = "beam";
          };
        };
      };
    };
    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "dev.notashelf.beer.desktop"
      ];
    };
  };
}
