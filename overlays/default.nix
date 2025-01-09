{...}: {
  imports = [
    ./pywalfox-rc.nix
    ./foot-transparency.nix
    ./mpd-discord-rpc-git.nix
    ./obs-pipewire-audio-capture-git.nix
		./nheko-1838-patch.nix
		./gamescope-1671-patch.nix
  ];
}
