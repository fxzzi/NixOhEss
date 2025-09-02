{
  writeShellApplication,
  hyprpaper,
  coreutils,
  wallust-script,
}:
writeShellApplication {
  name = "random-wall";
  runtimeInputs = [hyprpaper coreutils wallust-script];
  text = ''
    WALLPAPER_DIR="$XDG_DATA_HOME/walls/"
    CURRENT_WALL=$(hyprctl hyprpaper listloaded)

    # Get a random wallpaper that is not the current one
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

    # Apply the selected wallpaper
    wallust-script "$WALLPAPER"
  '';
}
