{
  config,
  pkgs,
  lib,
  xLib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.cfg.services.xdph;
in {
  options.cfg.services.xdph.enable = mkEnableOption "xdph";
  config = mkIf cfg.enable {
    xdg = {
      # we don't use these files
      autostart.enable = mkForce false;
      portal = {
        enable = true;
        # seems to help steam wanting to use chromium for some reason
        xdgOpenUsePortal = true;
      };
    };
    hj = {
      files = {
        ".config/hypr/xdph.conf" = {
          generator = xLib.generators.toHyprlang {};
          value = {
            screencopy.max_fps = 60; # don't need to capture more than 60fps
          };
        };
      };
    };
  };
}
