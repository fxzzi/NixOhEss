staticwall="$HOME/.local/state/wallpaper"

if [ -z "$1" ]; then
  echo "add wallpaper as arg"
  exit 1
fi

wallust run "$1" &

ln -sf "$1" "$staticwall"
hyprctl hyprpaper reload ,"$1"

# while wallust is still running, wait
while pgrep -x wallust >/dev/null; do
  sleep 0.1
done

# Restart dunst and update pywalfox
# killing dunst is kinda L. we would want to instead
# use the kind of new `dunstctl reload`. but we can't
# since it doesn't work correctly on wayland native.
# NOTE: https://github.com/dunst-project/dunst/pull/1350#issuecomment-2375288395
pkill dunst &
pywalfox --browser librewolf update
