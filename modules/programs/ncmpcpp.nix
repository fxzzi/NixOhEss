{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep mapAttrsToList isList mkEnableOption getExe;
  inherit (builtins) typeOf toString;

  renderSettings = settings: concatStringsSep "\n" (mapAttrsToList renderSetting settings);

  renderSetting = name: value: "${name}=${renderValue value}";

  renderValue = option:
    rec {
      int = toString option;
      bool =
        if option
        then "yes"
        else "no";
      string = option;
    }
    .${
      typeOf option
    };

  renderBindings = bindings: concatStringsSep "\n" (map renderBinding bindings);

  renderBinding = {
    key,
    command,
  }:
    concatStringsSep "\n  " ([''def_key "${key}"''] ++ maybeWrapList command);

  maybeWrapList = xs:
    if isList xs
    then xs
    else [xs];

  notifScript = pkgs.writeShellApplication {
    name = "mpd-notif";
    runtimeInputs = with pkgs; [
      ffmpeg
      libnotify
      mpc
    ];
    text = ''
      music_dir="$HOME/Music"
      previewdir="$XDG_STATE_HOME/ncmpcpp/previews"
      filename="$(mpc --format "$music_dir"/%file% current)"
      previewname="$previewdir/$(mpc --format %album% current | base64).png"

      [ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=96:96 "$previewname" >/dev/null 2>&1

      notify-send -r 27072 -a "mpd" "Now Playing" "$(mpc --format ' %title%\n %artist%' current)" -i "$previewname"
    '';
  };
in {
  options.cfg.programs.ncmpcpp.enable = mkEnableOption "ncmpcpp";
  config = lib.mkIf config.cfg.programs.ncmpcpp.enable {
    hj = {
      packages = with pkgs; [
        ncmpcpp
        notifScript
      ];
      files = {
        ".config/ncmpcpp/bindings".text = renderBindings [
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
        ".config/ncmpcpp/config".text = renderSettings {
          # Directories
          lyrics_directory = "/home/${config.cfg.core.username}/.local/share/ncmpcpp/lyrics/";

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
          execute_on_song_change = "${getExe notifScript}";
        };
      };
    };
    environment.shellAliases = {
      ncm = "${getExe pkgs.ncmpcpp}";
    };
  };
}
