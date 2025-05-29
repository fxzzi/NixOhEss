{
  pkgs,
  lib,
  config,
  ...
}: {
  options.cfg.gui.wallust.enable = lib.mkEnableOption "wallust";
  imports = [
    ./integrations.nix
  ];
  config = lib.mkIf config.cfg.gui.wallust.enable {
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
              if config.cfg.gui.fuzzel.enable
              then {
                template = "colors_fuzzel.ini";
                target = "~/.cache/wallust/colors_fuzzel.ini";
              }
              else null;
            hyprland =
              if config.cfg.gui.hypr.hyprland.enable
              then {
                template = "colors_hyprland.conf";
                target = "~/.cache/wallust/colors_hyprland.conf";
              }
              else null;
            ags =
              if config.cfg.gui.ags.enable
              then {
                template = "colors_ags.css";
                target = "~/.config/ags/colors_ags.css";
              }
              else null;
            foot =
              if config.cfg.gui.foot.enable
              then {
                template = "colors_foot.ini";
                target = "~/.cache/wallust/colors_foot.ini";
              }
              else null;
            pywalfox =
              if config.cfg.apps.browsers.librewolf.enable
              then {
                template = "colors_pywalfox.json";
                target = "~/.cache/wal/colors.json";
              }
              else null;
            wleave =
              if config.cfg.gui.wleave.enable
              then {
                template = "colors_wleave.css";
                target = "~/.config/wleave/colors_wleave.css";
              }
              else null;
            dunst =
              if config.cfg.gui.dunst.enable
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
