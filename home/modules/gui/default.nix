{
  inputs,
  lib,
  ...
}: {
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
    ./walker
  ];
  # option is used in librewolf, chromium, vesktop, and others
  options.cfg.gui.smoothScroll = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enables or disabled smooth scrolling where possible.";
    };
  };
  config = {
    home.file."walls".source = "${inputs.walls}/images"; # wallpapers
  };
}
