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
            // optionalAttrs config.cfg.programs.proton.enable {
              # picked up from Steam/compatibilitytools.d
              version = "GE-Proton";
            };
          };
        };
      };
    };
  };
}
