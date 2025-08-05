{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf mkBefore getExe;
  cfg = config.cfg.programs.fastfetch;
  icon = ./sixels/${cfg.icon}.sixel;
in {
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
          "kunzoz"
        ];
        default = "azzi";
        description = "Configures which icon you would like to display on fastfetch.";
      };
    };
  };
  config = mkIf cfg.enable {
    hj = {
      packages = [pkgs.fastfetchMinimal];
      xdg.config.files."fastfetch/config.jsonc" = {
        generator = lib.generators.toJSON {};
        value = {
          general = {
            # detecting hyprland version on NixOS is slow.
            detectVersion = false;
          };
          logo = {
            source = "${icon}";
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
              keyColor = "green";
              format = "{1}@{2}";
            }
            {
              type = "os";
              key = " os";
              keyColor = "green";
              format = "{2}";
            }
            {
              type = "wm";
              key = " cm";
              keyColor = "blue";
              format = "{1}";
            }
            {
              type = "terminal";
              key = " tr";
              keyColor = "blue";
              format = "{0}";
            }
            {
              type = "memory";
              key = "󰍛 mm";
              keyColor = "yellow";
              format = "{1}";
            }
            {
              # days since install
              type = "disk";
              key = "󱦟 dy";
              keyColor = "yellow";
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
    environment.interactiveShellInit = mkIf cfg.shellIntegration (mkBefore # put at the start of the file.
      
      # sh
      ''
        ${getExe pkgs.fastfetchMinimal}
      '');
  };
}
