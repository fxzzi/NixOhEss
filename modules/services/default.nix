{
  imports = [
    ./mpd
    ./syncthing.nix
    ./gcr-ssh-agent.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprsunset.nix
    ./xdph.nix
    ./dunst.nix
    ./opentabletdriver.nix
    ./wl-clip-persist.nix
    ./mate-polkit.nix
    ./sunshine.nix
    ./watt.nix
    ./scx.nix
    ./pipewire
    ./mediamtx.nix
    ./greetd.nix
    ./printing.nix
    ./getty-tty1.nix
    ./mullvad.nix
    ./stash.nix
    ./nvidia_oc.nix
  ];
  config = {
    # Disable speech-dispatcher as its unneeded in my case.
    services.speechd.enable = false;
  };
}
