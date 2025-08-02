{lib, ...}: {
  imports = [
    ./cursor
  ];

  options.cfg.gui.smoothScroll = {
    enable = lib.mkEnableOption "smooth scrolling";
  };
}
