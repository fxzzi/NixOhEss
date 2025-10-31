{
  writeShellApplication,
  hyprland,
}:
writeShellApplication {
  name = "sunset";
  runtimeInputs = [hyprland];
  text = ''
    if [ -e /tmp/sunsetLock ]; then
      echo "Resetting temperature"
      hyprctl hyprsunset identity
      rm /tmp/sunsetLock
    else
      echo "Setting temperature to $1"
      hyprctl hyprsunset temperature "$1"
      touch /tmp/sunsetLock
    fi
  '';
}
