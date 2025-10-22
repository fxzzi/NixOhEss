{
  writeShellApplication,
  opusTools,
}:
writeShellApplication {
  name = "flac2opus";
  runtimeInputs = [opusTools];
  text = ''
    for file in *.flac **/*.flac; do
      output="''${file%.flac}.ogg"
      echo "Converting: $file -> $output"
      if opusenc --bitrate 128 "$file" "$output"; then
        echo "Successfully converted: $file"
      else
        echo "Failed to convert: $file"
      fi
    done
    echo "All conversions complete."
  '';
}
