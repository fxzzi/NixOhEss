{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    getExe
    mkAfter
    ;
  cfg = config.cfg.programs.fastfetch;
  iconPath = ./images/${cfg.icon}.jpg;
  # Generate sixel using chafa
  icon = pkgs.runCommand "fastfetch-icon" { } ''
    ${getExe pkgs.chafa} ${iconPath} -s 18 --format sixel > $out
  '';
in
{
  options = {
    cfg.programs.fastfetch = {
      enable = mkEnableOption "fastfetch";
      shellIntegration = mkOption {
        type = types.bool;
        default = false;
        description = "Makes fastfetch run on shell startup";
      };
      icon = mkOption {
        type = types.enum [
          "azzi"
          "azzi-laptop"
          "azzi-merl"
          "azzi-yawn"
          "tomoe"
          "kunzoz"
        ];
        default = "azzi";
        description = "Configures which icon you would like to display on fastfetch.";
      };
    };
  };
  config = mkIf cfg.enable {
    hj = {
      packages = [ pkgs.fastfetch ];
      xdg.config.files."fastfetch/config.jsonc" = {
        generator = lib.generators.toJSON { };
        value = {
          general = {
            # detecting hyprland version on NixOS is slow.
            detectVersion = false;
          };
          display = {
            separator = " - ";
          };
          logo = {
            source = icon;
            type = "raw";
            height = 9;
            width = 16;
            padding = {
              top = 1;
              left = 1;
            };
          };
          modules = [
            {
              type = "title";
              key = " hs";
              keyColor = "italic_green";
              format = "{1}@{2}";
            }
            {
              type = "os";
              key = " os";
              keyColor = "italic_green";
              format = "{2}";
            }
            # HACK: just read from env var since it's much faster
            {
              type = "custom";
              key = " cm";
              keyColor = "italic_blue";
              format = "{$XDG_CURRENT_DESKTOP}";
            }
            {
              type = "terminal";
              key = " tr";
              keyColor = "italic_blue";
              format = "{0}";
            }
            {
              type = "memory";
              key = "󰍛 mm";
              keyColor = "italic_yellow";
              format = "{1}";
            }
            {
              # days since install
              type = "disk";
              key = "󱦟 dy";
              keyColor = "italic_yellow";
              folders = "/";
              format = "{days} days";
            }
            "break"
            {
              type = "custom";
              format = "{#90}󰊠 {#31}󰊠 {#32}󰊠 {#33}󰊠 {#34}󰊠 {#35}󰊠 {#36}󰊠 {#37}󰊠";
            }
          ];
        };
      };
    };
    programs.zsh = lib.mkIf cfg.shellIntegration {
      interactiveShellInit = mkAfter ''
        if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
          ${getExe pkgs.fastfetch}
          # HACK: move cursor up 3 lines to avoid large gap between ff and prompt
          printf '\033[3A'
        fi
      '';
    };
  };
}
