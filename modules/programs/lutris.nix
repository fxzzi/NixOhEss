{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionalAttrs;
  cfg = config.cfg.programs.lutris;
in
{
  options.cfg.programs.lutris.enable = mkEnableOption "lutris";
  config = mkIf cfg.enable {
    hj = {
      packages = [ pkgs.lutris-free ];
      xdg.data.files = {
        "lutris/runners/wine/GE-Proton" = mkIf config.cfg.programs.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
        "lutris/system.yml" = {
          generator = lib.generators.toYAML { };
          value = {
            system =
              optionalAttrs config.cfg.programs.obs-studio.enable {
                env.OBS_VKCAPTURE = "1";
              }
              // optionalAttrs config.cfg.programs.mangohud.enable {
                mangohud = true;
              };
          };
        };
        "lutris/runners/wine.yml" = {
          generator = lib.generators.toYAML { };
          value = {
            wine = {
              # we use ntsync
              esync = false;
              fsync = false;
              fsr = false;
            }
            // optionalAttrs config.cfg.programs.proton-ge.enable {
              # use the above sourced GE-Proton
              version = "GE-Proton";
            };
          };
        };
      };
    };
  };
}
