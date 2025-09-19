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
  inherit (pkgs) symlinkJoin;
  foot = pkgs.foot.overrideAttrs {
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
in {
  options.cfg.programs.foot.enable = mkEnableOption "foot";
  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      package = symlinkJoin {
        inherit (foot) name pname version meta;
        paths = [foot];
        # remove foot desktop files for server and client, as
        # we just use standalone anyway
        postBuild = ''
          unlink $out/share/applications/footclient.desktop
          unlink $out/share/applications/foot-server.desktop
        '';
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
          alpha = 0.80;
          alpha-mode = "matching";
        };
      };
    };
    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = ["foot.desktop"];
      };
    };
  };
}
