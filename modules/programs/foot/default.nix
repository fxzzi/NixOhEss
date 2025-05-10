{
  lib,
  config,
  pkgs,
  npins,
  ...
}: let
  pin = npins.foot;
in {
  options.cfg.gui.foot.enable = lib.mkEnableOption "foot";
  config = lib.mkIf config.cfg.gui.foot.enable {
    programs.foot = {
      enable = true;
      package = pkgs.foot.overrideAttrs {
        pname = "foot-transparency";
        version = "0-unstable-${npins.foot.revision}";
        src = pkgs.fetchFromGitea {
          domain = "codeberg.org";
          owner = "fazzi";
          repo = "foot";
          rev = pin.revision;
          sha256 = pin.hash;
        };
      };
      settings = {
        main = {
          font = "monospace:size=13";
          pad = "12x12 center";
          transparent-fullscreen = true;
        };
        cursor = {
          style = "beam";
        };
        mouse = {
          hide-when-typing = true;
        };
        colors = {
          alpha = 0.75;
          alpha-mode = "matching";
        };
        bell.system = false;
      };
    };
  };
}
