{
  writeShellApplication,
  coreutils,
  wallust-script,
}:
writeShellApplication {
  name = "random-wall";
  runtimeInputs = [coreutils wallust-script];
  text = ''
    WALLPAPER_DIR="$XDG_DATA_HOME/walls/"
    CURRENT_WALL=$(basename "$(readlink -f "$XDG_STATE_HOME/wallpaper")")

    # Get a random wallpaper that is not the current one
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f -not -name "$CURRENT_WALL" | shuf -n 1)

    # Apply the selected wallpaper
    wallust-script "$WALLPAPER"
  '';
}
