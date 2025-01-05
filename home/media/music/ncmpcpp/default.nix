{ pkgs, config, ... }:
{
  home.packages = with pkgs; [ libnotify ];
  programs.ncmpcpp = {
    enable = true;
    bindings = [
      {
        key = "+";
        command = "volume_up";
      }
      {
        key = "=";
        command = "volume_up";
      }
      {
        key = "_";
        command = "volume_down";
      }
      {
        key = "-";
        command = "volume_down";
      }
    ];
    settings = {
      # Directories
      lyrics_directory = "${config.xdg.dataHome}/ncmpcpp/lyrics/";

      # Mouse and scrolling
      mouse_support = "yes";
      lines_scrolled = "1";

      # Playlist settings
      playlist_shorten_total_times = "yes";
      autocenter_mode = "yes";

      # Editor
      external_editor = "nvim";

      # Progress bar settings
      progressbar_elapsed_color = "blue";
      progressbar_color = "black";
      progressbar_look = "▃▃▃";

      # UI
      user_interface = "alternative";
      playlist_display_mode = "classic";
      song_list_format = "$5{%a $2»$8 %t}$0";
      # hide playlist info
      header_visibility = "no";
      # hide current song highlight after 1 second
      playlist_disable_highlight_delay = 1;

      # Notifications
      execute_on_song_change = "mpd-notif.sh";
    };
  };
}
