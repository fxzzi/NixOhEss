{inputs, ...}: {
  imports = [
    ./ags
    ./fonts
    ./foot
    ./fuzzel
    ./hypr
    ./toolkits
    ./wallust # technically its cli but it does gui styling so im leaving it here.
    ./wleave
    ./dunst
  ];
  config = {
    home.file."walls".source = "${inputs.walls}/images"; # wallpapers
  };
}
