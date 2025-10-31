{
  writeShellApplication,
  wireplumber,
  dunst,
  libcanberra-gtk3,
}:
writeShellApplication {
  name = "audio";
  runtimeInputs = [wireplumber dunst libcanberra-gtk3];
  text = ''
    # Function to handle volume notifications
    volume_noti() {
    	volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')

      if (( volume > 70 )); then
          icon=notification-audio-volume-high
      elif (( volume > 40 )); then
          icon=notification-audio-volume-medium
      else
          icon=notification-audio-volume-low
      fi

    	dunstify -a "audio" -r "9997" -h int:value:"$volume" -i "$icon" "Volume" "''${volume}%"
    	canberra-gtk-play -i audio-volume-change &
    }

    # Function to handle sink notifications
    sink_noti() {
    	if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
    		dunstify -i notification-audio-volume-muted -a "audio" -r 9997 "Volume" "Muted"
    	else
    		volume_noti
    	fi
    }

    # Function to handle source notifications
    source_noti() {
    	if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"; then
    		dunstify -i microphone-sensitivity-muted -a "audio" -r 9996 "Microphone" "Muted"
    	else
    		dunstify -i microphone-sensitivity-high -a "audio" -r 9996 "Microphone" "Unmuted"
    	fi
    }

    # Main script logic
    case $1 in
    help)
      echo "invalid command"
    	exit 0
    	;;
    vol)
    	case $2 in
    	up)
    		wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    		wpctl set-volume @DEFAULT_AUDIO_SINK@ "$3%+" --limit 1.0
    		volume_noti
    		exit 0
    		;;
    	down)
    		wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    		wpctl set-volume @DEFAULT_AUDIO_SINK@ "$3%-"
    		volume_noti
    		exit 0
    		;;
    	toggle)
    		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    		sink_noti
    		exit 0
    		;;
    	esac
    	;;
    mic)
    	[ "$2" = "toggle" ] && wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && source_noti
    	exit 0
    	;;
    *)
    	echo "Invalid command: $1"
    	show_help
    	exit 1
    	;;
    esac
  '';
}
