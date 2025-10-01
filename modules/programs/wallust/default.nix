{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionalAttrs;
  cfg = config.cfg.programs.wallust;
in {
  options.cfg.programs.wallust.enable = mkEnableOption "wallust";
  imports = [
    ./integrations.nix
  ];
  config = mkIf cfg.enable {
    hj = {
      packages = with pkgs; [
        wallust
      ];
      xdg.config.files = {
        "wallust/templates".source = ./templates;
        "wallust/wallust.toml" = {
          generator = (pkgs.formats.toml {}).generate "wallust.toml";
          value = {
            check_contrast = true;
            backend = "resized";
            color_space = "lch";
            templates =
              {}
              // optionalAttrs config.cfg.programs.fuzzel.enable {
                fuzzel = {
                  template = "colors_fuzzel.ini";
                  target = "~/.cache/wallust/colors_fuzzel.ini";
                };
              }
              // optionalAttrs config.cfg.programs.hyprland.enable {
                hyprland = {
                  template = "colors_hyprland.conf";
                  target = "~/.cache/wallust/colors_hyprland.conf";
                };
              }
              // optionalAttrs config.cfg.services.ags.enable {
                ags = {
                  template = "colors_ags.css";
                  target = "~/.config/ags/colors_ags.css";
                };
              }
              // optionalAttrs config.cfg.programs.foot.enable {
                foot = {
                  template = "colors_foot.ini";
                  target = "~/.cache/wallust/colors_foot.ini";
                };
              }
              // optionalAttrs config.cfg.programs.librewolf.enable {
                pywalfox = {
                  template = "colors_pywalfox.json";
                  target = "~/.cache/wal/colors.json";
                };
              }
              // optionalAttrs config.cfg.programs.wleave.enable {
                wleave = {
                  template = "colors_wleave.css";
                  target = "~/.config/wleave/colors_wleave.css";
                };
              }
              // optionalAttrs config.cfg.services.dunst.enable {
                dunst = {
                  template = "99-wallust.conf";
                  target = "~/.config/dunst/dunstrc.d/99-wallust.conf";
                };
              };
          };
        };
      };
    };
  };
}
