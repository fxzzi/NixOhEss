{
  config,
  lib,
  ...
}: {
  options.cfg.audio.pipewire.enable = lib.mkEnableOption "pipewire";
  config = lib.mkIf config.cfg.audio.pipewire.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      extraConfig.pipewire."92-quantum" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 128;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 512;
        };
      };
      extraConfig.pipewire-pulse."92-quantum" = {
        context.modules = [
          {
            name = "libpipewire-module-rtkit";
            args = {
              "nice.level" = -20;
              "rt.prio" = 99;
            };
          }
          {
            name = "libpipewire-module-protocol-pulse";
            args.pulse = {
              min.req = "32/48000";
              default.req = "128/48000";
              max.req = "512/48000";
              min.quantum = "32/48000";
              max.quantum = "512/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "128/48000";
          resample.quality = 1;
        };
      };
    };

    # Optional but recommended
    security.rtkit.enable = true;
  };
  imports = [./rnnoise.nix];
}
