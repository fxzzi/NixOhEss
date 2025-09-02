{
  writeShellApplication,
  hyprland,
  dunst,
}:
writeShellApplication {
  name = "brightness";
  runtimeInputs = [hyprland dunst];
  text = ''
    # Function to send brightness change notification
    notification() {
      # Get current brightness level using hyprctl hyprsunset and convert to integer
      brightness=$(hyprctl hyprsunset gamma | awk '{print int($1)}')
      # Send notification about the brightness change
      dunstify -a "brightness" -u low -r "9999" -t 2000 -h int:value:"$brightness" -i "notification-display-brightness" "Brightness" "''${brightness}%"
    }

    # Main script logic
    case $1 in
    up)
      # Increase brightness by 10
      current_brightness=$(hyprctl hyprsunset gamma | awk '{print int($1)}')
      new_brightness=$((current_brightness + $2))
      hyprctl hyprsunset gamma $new_brightness
      ;;
    down)
      # Decrease brightness by 10, ensuring it does not go below 30
      current_brightness=$(hyprctl hyprsunset gamma | awk '{print int($1)}')
      new_brightness=$((current_brightness - $2))
      if [ "$new_brightness" -lt 30 ]; then
        new_brightness=30
      fi
      hyprctl hyprsunset gamma $new_brightness
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
