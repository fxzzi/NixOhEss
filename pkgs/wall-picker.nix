{
  writeShellApplication,
  libsixel,
  fzf,
  wallust-script,
}:
writeShellApplication {
  name = "wall-picker";
  runtimeInputs = [libsixel fzf wallust-script];
  text = ''
    # ipc must be turned on inside hyprpaper.conf

    bgdir="$XDG_DATA_HOME/walls/" # the directory where all wallpapers are stored

    # use find instead of ls to get list of files (no directories), strip leading path
    bgfile=$(find "$bgdir" -maxdepth 1 -type f -printf "%f\n" 2>/dev/null | fzf --height 100% \
      --preview "img2sixel --width 1200 --height auto -q low $bgdir/{} 2>/dev/null" \
      --preview-window=right:75%:wrap)

    # check if wallpaper was selected, if not - exit
    if [ -z "$bgfile" ]; then
      echo "No wallpaper selected..."
      exit 1
    fi

    # apply selected wallpaper
    wallust-script "$bgdir/$bgfile"
  '';
}
