{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cli.fastfetch.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables fastfetch, for sysinfo.";
  };
  options.cli.fastfetch.zshIntegration = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables fastfetch inside zshrc";
  };
  config = lib.mkIf config.cli.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        "logo" = {
          "source" = "${./azzi.sixel}";
          "type" = "raw";
          "height" = 9;
          "width" = 17;
          "padding" = {
            "top" = 1;
            "left" = 1;
          };
        };
        "modules" = [
          {
            "type" = "title";
            "key" = " hs";
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
    programs.zsh.initExtraFirst = lib.mkIf config.cli.fastfetch.zshIntegration ''
      if [ -z $WAYLAND_DISPLAY ]; then
        ${lib.getExe pkgs.fastfetch} -l none
      else
        ${lib.getExe pkgs.fastfetch}
      fi
    '';
  };
}
