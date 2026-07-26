{
  writeShellApplication,
  wallust,
}:
writeShellApplication {
  name = "wallust-script";
  runtimeInputs = [wallust];
  text = ''
    STATICWALL="$XDG_STATE_HOME/wallpaper"

    if [ -z "$1" ]; then
      echo "add wallpaper as arg"
      exit 1
    fi

    # link new wall to static location
    ln -sf "$1" "$STATICWALL"

    # generate colours and configs with colours
    wallust run "$1"
  '';
}
