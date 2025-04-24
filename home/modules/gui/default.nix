{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (config.cfg.gui) walls;
in {
  options.cfg.gui.walls.directory = lib.mkOption {
    type = lib.types.str;
    default = "images";
    description = "Changes the directory used for the wallpapers.";
  };
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
    xdg.dataFile."walls".source = "${inputs.walls}/${walls.directory}"; # wallpapers
  };
}
