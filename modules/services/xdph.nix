{
  config,
  lib,
  lib',
  ...
}: let
  inherit (lib'.generators) toHyprlang;
in {
  options.cfg.gui.hypr.xdph.enable = lib.mkEnableOption "xdph";
  config = lib.mkIf config.cfg.gui.hypr.xdph.enable {
    hj = {
      files = {
        ".config/hypr/xdph.conf".text = toHyprlang {} {
          screencopy.max_fps = 60; # don't need to capture more than 60fps
        };
      };
    };
  };
}
