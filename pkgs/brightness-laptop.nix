{
  writeShellApplication,
  brightnessctl,
  dunst,
}:
writeShellApplication {
  name = "brightness-laptop";
  runtimeInputs = [brightnessctl dunst];
  text = ''
    exponent=4

    # Function to send brightness change notification
    notification() {
      brightness=$(brightnessctl -e''${exponent} -m | cut -d',' -f4 | tr -d '%')
      dunstify -a "brightness" -u low -r "9999" -t 2000 \
        -h int:value:"$brightness" \
        -i "notification-display-brightness" "Brightness" "''${brightness}%"
    }

    # Main script logic
    case $1 in
    help)
      show_help
      exit 0
      ;;
    up)
      brightnessctl -e''${exponent} set "$2"%+
      ;;
    down)
      brightnessctl -e''${exponent} set "$2"%-
      ;;
    *)
      exit 1
      ;;
    esac

    # Send notification after adjusting brightness
    notification
    exit 0
  '';
}
