{
  config = {
    services = {
      # disable speech-dispatcher
      speechd.enable = false;
      # for passwords
      # FIXME: doesn't fucken auto unlock half the time????
      gnome.gnome-keyring.enable = true;
    };
  };
}
