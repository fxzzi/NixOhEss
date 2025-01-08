# Function to send brightness change notification
notification() {
    # Get current brightness level
		brightness="$(light -G | awk '{print int($1)}' )"
    # Send notification about the brightness change
    dunstify -a "brightness" -u low -r "9999" -t 2000 -h int:value:"$brightness" -i "notification-display-brightness" "Brightness" "${brightness}%"
}

# Main script logic
case $1 in
    help)
        show_help
        exit 0
        ;;
    up)
        # Increase brightness by the specified increment value
        light -A "$2"
        ;;
    down)
        # Decrease brightness by the specified increment value
        light -U "$2"
        ;;
    *)
        exit 1
        ;;
esac

# Send notification after adjusting brightness
notification
exit 0
