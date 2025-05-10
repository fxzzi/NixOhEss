{lib, ...}: {
  imports = [
    ./cursor
    ./fonts
    ./qt
    ./wallust
    ./gtk.nix
  ];

  options.cfg.gui.smoothScroll = {
    enable = lib.mkEnableOption "smooth scrolling";
  };
}
