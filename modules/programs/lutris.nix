{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionalAttrs;
  cfg = config.cfg.programs.lutris;
in {
  options.cfg.programs.lutris.enable = mkEnableOption "lutris";
  config = mkIf cfg.enable {
    hj = {
      packages = [pkgs.lutris-free];
      xdg.data.files = {
        "lutris/runners/wine/GE-Proton" = mkIf config.cfg.programs.proton-ge.enable {
          source = pkgs.proton-ge-bin.steamcompattool;
        };
        "lutris/system.yml" = {
          generator = lib.generators.toYAML {};
          value = {
            system = {
              env = {
                OBS_VKCAPTURE = optionalAttrs config.cfg.programs.obs-studio.vkcapture.enable 1;
                # allow using the nvidia reflex layer.
                # according to nvidia it can cause issues in apps which
                # don't even use reflex, so enable it in here only for lutris
                DXVK_NVAPI_VKREFLEX = optionalAttrs config.cfg.hardware.nvidia.enable 1;
                # https://github.com/Korthos-Software/low_latency_layer
                # LOW_LATENCY_LAYER = optionalAttrs config.cfg.hardware.amdgpu.enable 1;
              };
              # useful to add mangohud here, as lutris can
              # apply it to opengl games too.
              mangohud = optionalAttrs config.cfg.programs.mangohud.enable 1;
            };
          };
        };
        "lutris/runners/wine.yml" = {
          generator = lib.generators.toYAML {};
          value = {
            wine = {
              # we use ntsync
              esync = false;
              fsync = false;
              fsr = false;
              # use the above sourced GE-Proton
              version = optionalAttrs config.cfg.programs.proton-ge.enable "GE-Proton";
            };
          };
        };
      };
    };
  };
}
