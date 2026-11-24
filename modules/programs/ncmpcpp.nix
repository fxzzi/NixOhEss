{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption getExe mkIf;
  cfg = config.cfg.programs.ncmpcpp;
in
{
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
          alternative_header_first_line_format=$b{%t}|{%f}$/b
          autocenter_mode=yes
          connected_message_on_startup=no
          current_item_prefix="$(blue)▍$(end) $b"
          current_item_suffix=$/b
          external_editor=nvim
          header_visibility=no
          lines_scrolled=1
          lyrics_directory=~/.local/share/ncmpcpp/lyrics/
          media_library_primary_tag=album_artist
          mouse_support=yes
          now_playing_prefix="$b$5 "
          now_playing_suffix=$/b$9
          playlist_disable_highlight_delay=1
          playlist_display_mode=classic
          playlist_shorten_total_times=yes
          progressbar_color=black
          progressbar_elapsed_color=blue
          progressbar_look=━●━
          song_list_format=$5{$i%a$/i $2»$8 %t}$0
          user_interface=alternative
        '';
      };
    };
    environment.shellAliases = {
      ncm = getExe pkgs.ncmpcpp;
    };
  };
}
