{
  writeShellApplication,
  wallust,
  dunst,
}:
writeShellApplication {
  name = "wallust-script";
  runtimeInputs = [wallust dunst];
  text = ''
    STATICWALL="$XDG_STATE_HOME/wallpaper"

    if [ -z "$1" ]; then
      echo "add wallpaper as arg"
      exit 1
    fi

    # link new wall to static location
    ln -sf "$1" "$STATICWALL"

    # set new wallpaper
    hyprctl hyprpaper wallpaper ", $1"

    # generate colours and configs with colours
    wallust run "$1"

    # avoid potential race conditions
    sleep 0.5

    # restart dunst and update pywalfox
    dunstctl reload &
  '';
}
