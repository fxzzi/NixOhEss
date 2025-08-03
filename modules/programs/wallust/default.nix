{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
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
      files = {
        ".config/wallust/templates".source = ./templates;

        ".config/wallust/wallust.toml".source = (pkgs.formats.toml {}).generate "wallust" {
          check_contrast = true;
          backend = "resized";
          color_space = "lch";
          templates = {
            fuzzel =
              if config.cfg.programs.fuzzel.enable
              then {
                template = "colors_fuzzel.ini";
                target = "~/.cache/wallust/colors_fuzzel.ini";
              }
              else null;
            hyprland =
              if config.cfg.programs.hyprland.enable
              then {
                template = "colors_hyprland.conf";
                target = "~/.cache/wallust/colors_hyprland.conf";
              }
              else null;
            ags =
              if config.cfg.programs.ags.enable
              then {
                template = "colors_ags.css";
                target = "~/.config/ags/colors_ags.css";
              }
              else null;
            foot =
              if config.cfg.programs.foot.enable
              then {
                template = "colors_foot.ini";
                target = "~/.cache/wallust/colors_foot.ini";
              }
              else null;
            pywalfox =
              if config.cfg.programs.librewolf.enable
              then {
                template = "colors_pywalfox.json";
                target = "~/.cache/wal/colors.json";
              }
              else null;
            wleave =
              if config.cfg.programs.wleave.enable
              then {
                template = "colors_wleave.css";
                target = "~/.config/wleave/colors_wleave.css";
              }
              else null;
            dunst =
              if config.cfg.services.dunst.enable
              then {
                template = "99-wallust.conf";
                target = "~/.config/dunst/dunstrc.d/99-wallust.conf";
              }
              else null;
          };
        };
      };
    };
  };
}
