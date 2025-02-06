{
  pkgs,
  lib,
  config,
  ...
}: {
  options.gui.wallust.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables wallust and its configs.";
  };
  imports = [
    ./integrations.nix
  ];
  config = lib.mkIf config.gui.wallust.enable {
    home.packages = with pkgs; [
      wallust
    ];
    xdg.configFile."wallust/templates".source = ./templates;

    xdg.configFile."wallust/wallust.toml".source = (pkgs.formats.toml {}).generate "wallust" {
      check_contrast = true;
      backend = "wal";
      color_space = "lch";
      templates = {
        fuzzel =
          if config.gui.fuzzel.enable
          then {
            template = "colors_fuzzel.ini";
            target = "~/.cache/wallust/colors_fuzzel.ini";
          }
          else null;
        hyprland =
          if config.gui.hypr.hyprland.enable
          then {
            template = "colors_hyprland.conf";
            target = "~/.cache/wallust/colors_hyprland.conf";
          }
          else null;
        ags =
          if config.gui.ags.enable
          then {
            template = "colors_ags.css";
            target = "~/.config/ags/colors_ags.css";
          }
          else null;
        foot =
          if config.gui.foot.enable
          then {
            template = "colors_foot.ini";
            target = "~/.cache/wallust/colors_foot.ini";
          }
          else null;
        pywalfox =
          if config.apps.browsers.librewolf.enable
          then {
            template = "colors_pywalfox.json";
            target = "~/.cache/wal/colors.json";
          }
          else null;
        wleave =
          if config.gui.wleave.enable
          then {
            template = "colors_wleave.css";
            target = "~/.config/wlogout/colors_wleave.css";
          }
          else null;
        dunst =
          if config.gui.dunst.enable
          then {
            template = "99-wallust.conf";
            target = "~/.config/dunst/dunstrc.d/99-wallust.conf";
          }
          else null;
      };
    };
  };
}
