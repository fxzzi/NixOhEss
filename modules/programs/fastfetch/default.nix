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
          "kunzoz"
          "azzi-random" # randomly selects an azzi one
        ];
        default = "azzi-random";
        description = "Configures which icon you would like to display on fastfetch.";
      };
    };
  };
  config = mkIf cfg.enable {
    hj = {
      packages = [ pkgs.fastfetch ];
      xdg.config.files."fastfetch/images" = {
        source = "${./images}";
      };
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
            source =
              if cfg.icon == "azzi-random" then
                # randomize between all azzi icons
                "$XDG_CONFIG_HOME/fastfetch/images/azzi*.*"
              else
                "$XDG_CONFIG_HOME/fastfetch/images/${cfg.icon}.*";
            type = "kitty";
            height = 8;
            padding = {
              top = 1;
              left = 1;
              right = 2;
            };
          };
          modules = [
            "break"
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
        fi
      '';
    };
  };
}
