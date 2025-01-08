{
  config,
  lib,
  ...
}:
{
  options.gui.hypr.xdph.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables xdph and its configs.";
  };
  config = lib.mkIf config.gui.hypr.xdph.enable {
    home.file."${config.xdg.configHome}/hypr/xdph.conf".text = ''
      screencopy {
      	max_fps = 60
      }
    '';
  };
}
