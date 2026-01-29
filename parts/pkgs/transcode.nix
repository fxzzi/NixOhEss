{
  writeShellApplication,
  ffmpeg,
}:
writeShellApplication {
  name = "transcode";
  runtimeInputs = [ffmpeg];
  text = ''
    # Default values
    input_file=""
    output_resolution=""
    cq_level="30"
    output_file=""
    reencode_audio=false

    # Show usage
    usage() {
        echo "Usage: $0 [--reencode-audio] input_file [output_resolution] [cq_level] [output_file]"
        echo ""
        echo "Options:"
        echo "  --reencode-audio   Re-encode audio to AAC 96kbps (default:  copy audio stream)"
        echo ""
        echo "Arguments:"
        echo "  input_file         Input video file (required)"
        echo "  output_resolution  Output resolution, e.g., 1920:1080 (optional)"
        echo "  cq_level           Constant quality level 0-51, lower is better (default: 30)"
        echo "  output_file        Custom output filename (optional)"
        echo ""
        echo "Examples:"
        echo "  $0 video.mkv"
        echo "  $0 --reencode-audio video. mkv"
        echo "  $0 video.mkv 1280:720"
        echo "  $0 --reencode-audio video.mkv 1920:1080 23"
        echo "  $0 video.mkv 1920:1080 23 output.mp4"
        exit 1
    }

    # Parse flags
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --reencode-audio)
                reencode_audio=true
                shift
                ;;
            --help|-h)
                usage
                ;;
            -*)
                echo "Error: Unknown option: $1"
                usage
                ;;
            *)
                break
                ;;
        esac
    done

    # Check minimum arguments
    if [ "$#" -lt 1 ]; then
        usage
    fi

    input_file="$1"

    # Check argument count before accessing to avoid unbound variable
    if [ "$#" -ge 2 ]; then
        output_resolution="$2"
    fi

    if [ "$#" -ge 3 ]; then
        cq_level="$3"
    fi

    if [ "$#" -ge 4 ]; then
        output_file="$4"
    fi

    # Validate input file exists
    if [ ! -f "$input_file" ]; then
        echo "Error: Input file '$input_file' not found."
        exit 1
    fi

    # Validate CQ level (0-51 for h264_nvenc)
    if ! [[ "$cq_level" =~ ^[0-9]+$ ]] || [ "$cq_level" -lt 0 ] || [ "$cq_level" -gt 51 ]; then
        echo "Error: CQ level must be between 0 and 51 (got: $cq_level)"
        exit 1
    fi

    # Determine output filename
    if [ -z "$output_file" ]; then
        if [ -n "$output_resolution" ]; then
            output_file="''${input_file%.*}-scaled.mp4"
        else
            output_file="''${input_file%.*}-transcoded. mp4"
        fi
    fi

    # Set audio codec parameters
    if [ "$reencode_audio" = true ]; then
        audio_codec="-c:a aac -b:a 96k"
        audio_info="AAC 96kbps"
    else
        audio_codec="-c:a copy"
        audio_info="Copy stream"
    fi

    # Show transcoding info
    echo "Transcoding:  $input_file -> $output_file"
    echo "Video CQ Level: $cq_level"
    echo "Audio: $audio_info"
    if [ -n "$output_resolution" ]; then
        echo "Resolution:  $output_resolution"
    fi
    echo ""

    # Execute ffmpeg command and check exit code directly
    if [ -n "$output_resolution" ]; then
        # shellcheck disable=SC2086
        if ffmpeg -y \
            -v quiet -stats \
            -threads 11 \
            -hwaccel cuda \
            -hwaccel_output_format cuda \
            -i "$input_file" \
            -vf "scale_cuda=$output_resolution" \
            $audio_codec \
            -c:v h264_nvenc \
            -cq:v "$cq_level" \
            "$output_file"; then
            echo ""
            echo "✓ Transcoding complete: $output_file"
        else
            echo ""
            echo "✗ Error: Transcoding failed"
            exit 1
        fi
    else
        # shellcheck disable=SC2086
        if ffmpeg -y \
            -v quiet -stats \
            -threads 11 \
            -hwaccel cuda \
            -hwaccel_output_format cuda \
            -i "$input_file" \
            $audio_codec \
            -c:v h264_nvenc \
            -cq:v "$cq_level" \
            "$output_file"; then
            echo ""
            echo "✓ Transcoding complete: $output_file"
        else
            echo ""
            echo "✗ Error: Transcoding failed"
            exit 1
        fi
    fi
  '';
}
