{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.programs.fuzzel;
in
{
  options.cfg.programs.fuzzel = {
    enable = mkEnableOption "fuzzel";
    disableCache = mkEnableOption "Disable fuzzel cache" // {
      default = true;
    };
  };
  config = mkIf cfg.enable {
    hj = {
      packages = [
        (pkgs.fuzzel.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [
            (pkgs.fetchpatch {
              url = "https://codeberg.org/dnkl/fuzzel/pulls/792.patch";
              hash = "sha256-+h1kp81kP+aIc3dDDrrySmT/Rn0Yiojq5OdHaxdJdPA=";
              excludes = [ "CHANGELOG.md" ];
            })
          ];
        }))
      ];
      xdg.config.files = {
        "wallust/wallust.toml".value.templates.fuzzel = mkIf config.cfg.programs.wallust.enable {
          target = "~/.cache/wallust/colors_fuzzel.ini";
          template = builtins.toFile "colors_fuzzel.ini" ''
            [colors]
            background={{background | saturate(0.2) | strip}}cc
            text={{foreground | strip}}ff
            prompt={{color4 | strip}}ff
            input={{foreground | strip}}ff
            match={{color12 | strip}}ff
            selection={{color0 | lighten(0.5) | strip}}55
            selection-match={{color4 | strip}}ff
            selection-text={{foreground | strip}}ff
            border={{color4 | strip}}aa
            placeholder={{color12 | darken(0.3) | strip}}ff       
          '';
        };
        "fuzzel/fuzzel.ini" = {
          generator = lib.generators.toINI { };
          value = {
            main = {
              font = "monospace:size=16";
              use-bold = true;
              line-height = "28";
              prompt = "' '";
              layer = "overlay";
              lines = "12";
              icon-theme = "Papirus-Dark";
              horizontal-pad = "8";
              vertical-pad = "8";
              inner-pad = "6";
              filter-desktop = true;
              terminal = "xdg-terminal-exec";
              placeholder = "Search...";
              dpi-aware = false;
              # by default fuzzel sorts by most frequent
              cache = mkIf cfg.disableCache "/dev/null";
              include = mkIf config.cfg.programs.wallust.enable "~/.cache/wallust/colors_fuzzel.ini";

            };
            border = {
              radius = "0";
              width = "2";
            };
          };
        };
      };
    };
  };
}
