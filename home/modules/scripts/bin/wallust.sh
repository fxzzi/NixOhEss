STATICWALL="$XDG_STATE_HOME/wallpaper"

if [ -z "$1" ]; then
  echo "add wallpaper as arg"
  exit 1
fi

wallust run "$1" &

ln -sf "$1" "$STATICWALL"

hyprctl hyprpaper reload ,"$1"

# while wallust is still running, wait
while pgrep -x wallust >/dev/null; do
  sleep 0.5
done

# Restart dunst and update pywalfox
dunstctl reload &
pywalfox --browser librewolf update
