{
  writeShellApplication,
  ffmpeg,
  libnotify,
  mpc,
}:
writeShellApplication {
  name = "mpd-notif";
  runtimeInputs = [ffmpeg libnotify mpc];
  text = ''
    music_dir="$HOME/Music"
    previewdir="$XDG_STATE_HOME/ncmpcpp/previews"
    filename="$(mpc --format "$music_dir"/%file% current)"
    previewname="$previewdir/$(mpc --format %album% current | base64).png"

    # Create preview directory if it doesn't exist
    if [ ! -d "$previewdir" ]; then
      mkdir -p "$previewdir"
    fi

    [ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf "scale=96:96:force_original_aspect_ratio=increase,crop=96:96" "$previewname" >/dev/null 2>&1

    notify-send -r 27072 -a "mpd" "Now Playing" "$(mpc --format ' %title%\n %artist%' current)" -i "$previewname"
  '';
}
