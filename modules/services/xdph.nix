{
  config,
  lib,
  xLib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (xLib.generators) toHyprlang;
  cfg = config.cfg.services.xdph;
in {
  options.cfg.services.xdph.enable = mkEnableOption "xdph";
  config = mkIf cfg.enable {
    hj = {
      files = {
        ".config/hypr/xdph.conf".text = toHyprlang {} {
          screencopy.max_fps = 60; # don't need to capture more than 60fps
        };
      };
    };
  };
}
