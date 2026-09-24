{
  config = {
    hardware.audient-evo.config = {
      monitor = 50;
      input1 = {
        gain = 40;
        phantom = true;
      };
    };
    services.pipewire = {
      extraConfig.pipewire."10-adjust-allowed-rates" = {
        "context.properties" = {
          "default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
          ];
        };
      };

    };
  };
}
