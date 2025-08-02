{lib, ...}: {
  imports = [
    ./cursor
    ./qt
    ./gtk.nix
  ];

  options.cfg.gui.smoothScroll = {
    enable = lib.mkEnableOption "smooth scrolling";
  };
}
