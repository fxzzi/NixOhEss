{
  self',
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption getExe mkIf;
  cfg = config.cfg.programs.ncmpcpp;
in {
  options.cfg.programs.ncmpcpp.enable = mkEnableOption "ncmpcpp";
  config = mkIf cfg.enable {
    hj = {
      packages = [
        pkgs.ncmpcpp
      ];
      xdg.config.files = {
        "ncmpcpp/bindings".text = ''
          def_key "+"
            volume_up
          def_key "="
            volume_up
          def_key "_"
            volume_down
          def_key "-"
            volume_down
        '';
        "ncmpcpp/config".text = ''
          autocenter_mode=yes
          execute_on_song_change=${getExe self'.packages.mpd-notif} &
          external_editor=nvim
          header_visibility=no
          lines_scrolled=1
          lyrics_directory=~/.local/share/ncmpcpp/lyrics/
          mouse_support=yes
          playlist_disable_highlight_delay=1
          playlist_display_mode=classic
          playlist_shorten_total_times=yes
          progressbar_color=black
          progressbar_elapsed_color=blue
          progressbar_look=▃▃▃
          song_list_format=$5{%a $2»$8 %t}$0
          user_interface=alternative
        '';
      };
    };
    environment.shellAliases = {
      ncm = "${getExe pkgs.ncmpcpp}";
    };
  };
}
