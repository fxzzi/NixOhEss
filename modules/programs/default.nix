{lib, ...}: let
  inherit (lib) mkDefault mkEnableOption;
in {
  options.cfg.programs.smoothScroll = {
    enable = mkEnableOption "smooth scrolling" // {default = true;};
  };
  config = {
    programs = {
      # nano is enabled by default. no.
      # cmd-not-found is useless
      nano.enable = mkDefault false;
      command-not-found.enable = false;
    };
    # also dont install any of the default packages.
    environment.defaultPackages = mkDefault [];
  };
}
