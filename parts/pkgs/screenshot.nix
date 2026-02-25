{
  writeShellApplication,
  libcanberra-gtk3,
  jq,
  grim,
  slurp,
  wl-clipboard,
  wayfreeze,
  dunst,
}:
writeShellApplication {
  name = "screenshot";
  runtimeInputs = [libcanberra-gtk3 jq grim slurp wl-clipboard wayfreeze dunst];
  excludeShellChecks = ["SC2016"];
  text = ''
    # Screenshot the entire monitor, a selection, or active window
    # and then copies the image to your clipboard.
    # It also saves the image locally.

    fileName="Screenshot from $(date '+%y.%m.%d %H:%M:%S').png"
    screenshotDir="$HOME/Pictures/Screenshots"
    path="$screenshotDir/$fileName"
    # -l sets compression level. default is 6. the higher you
    # go the slower the screenshot takes to save.
    grimCmd="grim -t png -l 3"

    # make the screenshot directory if it doesn't already exist
    if [ ! -d "$screenshotDir" ]; then
      mkdir -p "$screenshotDir"
    fi

    case $1 in
    --monitor)
      monitorJson=$(hyprctl monitors -j | jq -r '.[] | select(.focused)')
      monName=$(echo "$monitorJson" | jq -r '.name')
      activeWsId=$(echo "$monitorJson" | jq -r '.activeWorkspace.id')

      # find a fullscreen window on the active workspace, if any
      fsStableId=$(hyprctl clients -j | jq -r --argjson ws "$activeWsId" 'map(select(.workspace.id == $ws and (.fullscreen // 0) != 0)) | .[0].stableId // empty')

      # if there's a fullscreen window, capture it directly by stable ID
      # so grim doesn't include bars/decorations. otherwise capture the output.
      if [ -n "$fsStableId" ]; then
        $grimCmd -T "$fsStableId" "$path"
      else
        $grimCmd -o "$monName" "$path"
      fi
      ;;
    --selection)
      wayfreeze --hide-cursor &
      PID=$!
      sleep .05
      # don't allow multiple slurps at once
      # nicer colours on slurp too
      $grimCmd -g "$(slurp -b '#0a0a0a77' -c '#FFFFFF' -s '#FFFFFF17' -w 2)" "$path" || echo "selection cancelled"
      kill $PID
      ;;
    --active)
      stableId=$(hyprctl activewindow -j | jq -r '.stableId')
      $grimCmd -T "$stableId" "$path" || echo "no active window"
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
