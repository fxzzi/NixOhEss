{
  writeShellApplication,
  dunst,
}:
writeShellApplication {
  name = "brightness";
  runtimeInputs = [dunst];
  text = ''
    # Function to send brightness change notification
    notification() {
      # Get current brightness level using hyprctl hyprsunset and convert to integer
      brightness=$(hyprctl hyprsunset gamma | awk '{print int($1)}')
      # Send notification about the brightness change
      dunstify -a "brightness" -u low -r "9999" -t 2000 -h int:value:"$brightness" -i "notification-display-brightness" "Brightness" "''${brightness}%"
    }

    case $1 in
    up)
      hyprctl hyprsunset gamma +10
      ;;
    down)
      # Decrease brightness by 10, ensuring it does not go below 30
      current_brightness=$(hyprctl hyprsunset gamma | awk '{print int($1)}')
      new_brightness=$((current_brightness - $2))
      if [ "$new_brightness" -gt 30 ]; then
        hyprctl hyprsunset gamma -10
      fi
      ;;
    *)
      echo "invalid cmd"
      exit 1
      ;;
    esac

    # Send notification after adjusting brightness
    notification
    exit 0
  '';
}
