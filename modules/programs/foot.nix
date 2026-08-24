{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.foot;
in
{
  options.cfg.programs.foot.enable = mkEnableOption "foot";
  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      package = pkgs.symlinkJoin {
        name = "foot";
        paths = [
          inputs.azzipkgs.packages.${pkgs.stdenv.hostPlatform.system}.foot-transparency
        ];

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
          pad = "6x6";
          transparent-fullscreen = true; # option added by my fork
        };
        cursor = {
          style = "beam";
        };
        mouse = {
          hide-when-typing = true;
        };
        colors-dark = {
          blur = "yes";
          alpha = 0.85;
          alpha-mode = "matching";
        };
        tweak.font-monospace-warn = false; # slightly faster startup times
        scrollback.lines = 100000;
      };
    };
    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "foot.desktop"
      ];
    };
  };
}
