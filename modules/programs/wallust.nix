{
  pkgs,
  lib,
  config,
  self,
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
      packages = [
        pkgs.wallust
        self.packages.${pkgs.stdenv.hostPlatform.system}.wallust-script
      ];
      xdg.config.files = {
        "wallust/wallust.toml" = {
          generator = (pkgs.formats.toml { }).generate "wallust.toml";
          value = {
            check_contrast = true;
            templates = {
              # contains one hex of the accent colour of current theme.
              # currently used in screenshot script for the border colour.
              # may be used for other things later.
              accent = {
                template = pkgs.writeText "accent.txt" "{{color4}}";
                target = "~/.cache/wallust/accent.txt";
              };
            };
          };
        };
      };
    };
  };
}
