{ pkgs, ... }: {
  home.packages = with pkgs; [ nicotine-plus picard ];
  imports = [ ./mpd ./ncmpcpp ];
}
