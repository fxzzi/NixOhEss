{
  writeShellApplication,
  libcanberra-gtk3,
  jq,
  grim,
  slurp,
  wl-clipboard,
  wayfreeze,
  hyprland,
  dunst,
}:
writeShellApplication {
  name = "screenshot";
  runtimeInputs = [libcanberra-gtk3 jq grim slurp wl-clipboard wayfreeze hyprland dunst];
  text = ''
    # Screenshot the entire monitor, a selection, or active window
    # and then copies the image to your clipboard.
    # It also saves the image locally.

    fileName="Screenshot from $(date '+%y.%m.%d %H:%M:%S').png"
    screenshotDir="$HOME/Pictures/Screenshots"
    path="$screenshotDir/$fileName"
    grimCmd="grim -t png -l 1"

    # make the screenshot directory if it doesn't already exist
    if [ ! -d "$screenshotDir" ]; then
      mkdir -p "$screenshotDir"
      echo "Directory '$screenshotDir' created successfully."
    fi

    case $1 in
    --monitor)
      if [ -z "$2" ]; then
        echo "give monitor output too"
        exit 1
      fi
       $grimCmd -o "$2" "$path"
      ;;
    --selection)
      wayfreeze --hide-cursor &
      PID=$!
      sleep .1
      # don't allow multiple slurps at once
      pidof slurp || ($grimCmd -g "$(slurp)" "$path" || echo "selection cancelled")
      kill $PID
      ;;
    --active)
      window_geometry=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
      $grimCmd -g "$window_geometry" "$path" || echo "no active window"
      ;;
    esac

    # if the screenshot was successful
    if [ -f "$path" ]; then
      canberra-gtk-play -i camera-shutter & # play shutter sound
      dunstify -i "$path" -a "screenshot" "Screenshot" "Copied to clipboard" -r 9998 &
      wl-copy < "$path" # copy to clipboard
      exit 0
    fi

    echo "Screenshot cancelled."
    exit 1
  '';
}
