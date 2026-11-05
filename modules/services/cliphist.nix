{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getExe
    getExe'
    ;
  cfg = config.cfg.services.cliphist;
in
{
  options.cfg.services.cliphist.enable = mkEnableOption "cliphist";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.cliphist
        pkgs.wl-clipboard
      ];
      systemd.services = {
        cliphist = self.lib.mkGraphicalService {
          description = "Wayland clipboard manager with support for multimedia";
          exec = "${getExe' pkgs.wl-clipboard "wl-paste"} --watch ${getExe pkgs.cliphist} store";
          extra = {
            environment = {
              CLIPHIST_PREVIEW_WIDTH = "75";
              CLIPHIST_MAX_ITEMS = "24";
              CLIPHIST_MIN_STORE_LENGTH = "2";
            };
            restartTriggers = [
              pkgs.cliphist
              pkgs.wl-clipboard
            ];
          };
        };
      };
    };
  };
}
