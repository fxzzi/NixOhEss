{
  writeShellApplication,
  vorbis-tools,
}:
writeShellApplication {
  name = "flac2vorbis";
  runtimeInputs = [vorbis-tools];
  text = ''
    shopt -s globstar nullglob
    for file in **/*.flac; do
      output="''${file%.flac}.ogg"
      echo "Converting: $file -> $output"
      if oggenc -q 7 "$file" -o "$output"; then
        echo "Successfully converted: $file"
      else
        echo "Failed to convert: $file"
      fi
    done
    echo "All conversions complete."
  '';
}
