{
  lib,
  config,
  pkgs,
  ...
}: let
  icon = ./sixels/${config.cfg.cli.fastfetch.icon}.sixel;
in {
  options = {
    cfg.cli.fastfetch = {
      enable = lib.mkEnableOption "fastfetch";
      shellIntegration = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Makes fastfetch run on shell startup";
      };
      icon = lib.mkOption {
        type = lib.types.enum [
          "azzi"
          "azzi-laptop"
          "kunzoz"
        ];
        default = "azzi";
        description = "Configures which icon you would like to display on fastfetch.";
      };
    };
  };
  config = lib.mkIf config.cfg.cli.fastfetch.enable {
    hj = {
      packages = [
        pkgs.fastfetch
      ];
      files.".config/fastfetch/config.jsonc".source = (pkgs.formats.json {}).generate "config.jsonc" {
        "logo" = {
          "source" = "${icon}";
          "type" = "raw";
          "height" = 9;
          "width" = 16;
          "padding" = {
            "top" = 1;
            "left" = 1;
          };
        };
        "modules" = [
          {
            "type" = "title";
            "key" = " hs";
            "keyColor" = "green";
            "format" = "{1}@{2}";
          }
          {
            "type" = "os";
            "key" = " os";
            "keyColor" = "green";
            "format" = "{2}";
          }
          {
            "type" = "wm";
            "key" = " cm";
            "keyColor" = "blue";
            "format" = "{1}";
          }
          {
            "type" = "terminal";
            "key" = " tr";
            "keyColor" = "blue";
            "format" = "{0}";
          }
          {
            "type" = "memory";
            "key" = "󰍛 mm";
            "keyColor" = "yellow";
            "format" = "{1}";
          }
          {
            "type" = "command";
            "key" = "󱦟 dy";
            "keyColor" = "yellow";
            "text" = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
          }
          "break"
          {
            "type" = "custom";
            "format" = "{#90}󰊠 {#31}󰊠 {#32}󰊠 {#33}󰊠 {#34}󰊠 {#35}󰊠 {#36}󰊠 {#37}󰊠";
          }
        ];
      };
    };
    environment.interactiveShellInit = lib.mkIf config.cfg.cli.fastfetch.shellIntegration (
      lib.mkBefore # put at the start of the file.
      
      # sh
      ''
        ${lib.getExe pkgs.fastfetch}
      ''
    );
  };
}
