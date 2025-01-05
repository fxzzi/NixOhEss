{ pkgs, config, ... }: {
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
          "key" = " os";
          "keyColor" = "green";
          "format" = "{3}";
        }
        {
          "type" = "wm";
          "key" = " wm";
          "keyColor" = "blue";
          "format" = "{1}";
        }
        {
          "type" = "packages";
          "key" = " pk";
          "keyColor" = "blue";
          "format" = "{1}";
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
          "text" =
            "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
        }
        "break"
        {
          "type" = "custom";
          "format" = "{#90}󰊠 {#31}󰊠 {#32}󰊠 {#33}󰊠 {#34}󰊠 {#35}󰊠 {#36}󰊠 {#37}󰊠";
        }
      ];
    };
  };
}
