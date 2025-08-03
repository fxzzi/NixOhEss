{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  imports = [
    ./cursor
  ];

  options.cfg.gui.smoothScroll = {
    enable = mkEnableOption "smooth scrolling";
  };
}
