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
          include = mkIf config.cfg.programs.wallust.enable "~/.cache/wallust/colors_foot.ini";
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
    hj.xdg.config.files = {
      "wallust/wallust.toml".value.templates.foot = mkIf config.cfg.programs.wallust.enable {
        target = "~/.cache/wallust/colors_foot.ini";
        template = builtins.toFile "colors_foot.ini" ''
          [colors-dark]
          foreground={{foreground | strip}}
          background={{background | strip}}
          selection-foreground={{background | strip}}
          selection-background={{foreground | strip}}
          urls={{color6 | strip}}

          regular0={{color0 | strip}}
          regular1={{color1 | strip}}
          regular2={{color2 | strip}}
          regular3={{color3 | strip}}
          regular4={{color4 | strip}}
          regular5={{color5 | strip}}
          regular6={{color6 | strip}}
          regular7={{color7 | strip}}

          bright0={{color8 | strip}}
          bright1={{color9 | strip}}
          bright2={{color10 | strip}}
          bright3={{color11 | strip}}
          bright4={{color12 | strip}}
          bright5={{color13 | strip}}
          bright6={{color14 | strip}}
          bright7={{color15 | strip}}
        '';
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
