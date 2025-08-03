{
  lib,
  config,
  pkgs,
  npins,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (builtins) substring;
  cfg = config.cfg.programs.foot;
  pin = npins.foot;
  inherit (pkgs) makeDesktopItem;
  # using this allows us to hide apps from runners like fuzzel.
  makeHiddenDesktopItem = name: desktopName:
    makeDesktopItem {
      inherit name;
      inherit desktopName;
      exec = "";
      noDisplay = true;
    };
in {
  options.cfg.programs.foot.enable = mkEnableOption "foot";
  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      package = pkgs.foot.overrideAttrs {
        pname = "foot-transparency";
        version = "0-unstable-${substring 0 8 pin.revision}";
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
          pad = "8x8";
          transparent-fullscreen = true; # option added by my fork
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
      };
    };
    hj = {
      packages = [
        # hide footclient and foot-server from runners. We don't use them.
        (makeHiddenDesktopItem "footclient" "Foot Client")
        (makeHiddenDesktopItem "foot-server" "Foot Server")
      ];
    };
  };
}
