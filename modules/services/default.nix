{
  config = {
    services = {
      # disable speech-dispatcher
      speechd.enable = false;
      # for passwords
      gnome.gnome-keyring.enable = true;
    };
  };
}
