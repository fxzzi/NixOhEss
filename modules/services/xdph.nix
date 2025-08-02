{
  config,
  lib,
  xLib,
  ...
}: let
  inherit (xLib.generators) toHyprlang;
in {
  options.cfg.services.xdph.enable = lib.mkEnableOption "xdph";
  config = lib.mkIf config.cfg.services.xdph.enable {
    hj = {
      files = {
        ".config/hypr/xdph.conf".text = toHyprlang {} {
          screencopy.max_fps = 60; # don't need to capture more than 60fps
        };
      };
    };
  };
}
