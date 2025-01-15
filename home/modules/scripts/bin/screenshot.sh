# Screenshot the entire monitor, a selection, or active window
# and then copies the image to your clipboard.
# It also saves the image locally.

fileName="Screenshot from $(date '+%y.%m.%d %H:%M:%S').png"
screenshotDir="$HOME/Pictures/Screenshots"
path="$screenshotDir/$fileName"

if [ ! -d "$screenshotDir" ]; then
	mkdir -p "$screenshotDir"
	echo "Directory '$screenshotDir' created successfully."
fi

case $1 in
--monitor)
	if [ -z "$2" ]; then
		echo "Error: Monitor output not specified."
		exit 1
	fi
	grim -t png -l 1 -o "$2" "$path"
	;;
--selection)
	wayfreeze --hide-cursor &
	PID=$!
	sleep .1
	grim -t png -l 1 -g "$(slurp)" "$path"
	kill $PID
	;;
--active)
	window_geometry=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')

	grim -t png -l 1 -g "$window_geometry" "$path"
	;;
*)
	echo "invalid cmd"
	exit 1
	;;
esac

if [ -f "$path" ]; then
	canberra-gtk-play -i camera-shutter -V "-10" &
	dunstify -i "$path" -a "screenshot" "Screenshot" "Copied to clipboard" -r 9998 &
	wl-copy <"$path"
	exit 0
fi

echo "Screenshot cancelled."
exit 1
