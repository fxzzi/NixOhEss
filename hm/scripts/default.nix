{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "audio.sh" (builtins.readFile ./audio.sh))
    (writeShellScriptBin "cycle-wall.sh" (builtins.readFile ./cycle-wall.sh))
    (writeShellScriptBin "gsettings.sh" (builtins.readFile ./gsettings.sh))
    (writeShellScriptBin "mpd-notif.sh" (builtins.readFile ./mpd-notif.sh))
    (writeShellScriptBin "screenshot.sh" (builtins.readFile ./screenshot.sh))
    (writeShellScriptBin "wall_picker.sh" (builtins.readFile ./wall_picker.sh))
    (writeShellScriptBin "brightness.sh" (builtins.readFile ./brightness.sh))
    (writeShellScriptBin "hyprlock.sh" (builtins.readFile ./hyprlock.sh))
    (writeShellScriptBin "random-wall.sh" (builtins.readFile ./random-wall.sh))
    (writeShellScriptBin "transcode.sh" (builtins.readFile ./transcode.sh))
    (writeShellScriptBin "wallust.sh" (builtins.readFile ./wallust.sh))
  ];
}

