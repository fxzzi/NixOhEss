{
  writeShellApplication,
  coreutils,
  netcat,
  wallust,
}:
writeShellApplication {
  name = "wallust-script";
  runtimeInputs = [
    coreutils
    netcat
    wallust
  ];
  text = ''
    STATICWALL="$XDG_STATE_HOME/wallpaper"
    CHROMA_SOCK="$XDG_RUNTIME_DIR/chroma.sock"

    if [ -z "$1" ]; then
      echo "add wallpaper as arg"
      exit 1
    fi

    WALL=$(realpath "$1")

    # link new wall to static location
    ln -sf "$WALL" "$STATICWALL"

    # tell chroma to swap the wallpaper on every output
    # echo "set_all $WALL" | nc -U "$CHROMA_SOCK"

    # reload chroma's config so default_image picks up the new symlink
    echo "reload" | nc -U "$CHROMA_SOCK"

    # generate colours and configs with colours
    wallust run "$WALL"
  '';
}
