{
  config = {
    services = {
      # disable speech-dispatcher
      speechd.enable = false;
      # use dbus-broker
      dbus.implementation = "broker";
    };
  };
}
