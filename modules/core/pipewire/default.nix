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
      extraConfig = {
        pipewire."92-quantum" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [44100 48000];
            "default.clock.quantum" = 2048;
            "default.clock.min-quantum" = 1024;
            "default.clock.max-quantum" = 4096;
          };
        };
        pipewire-pulse."92-quantum" = {
          "context.properties" = [
            {
              name = "libpipewire-module-protocol-pulse";
              args = {};
            }
          ];
          "pulse.properties" = {
            "pulse.min.req" = "1024/48000";
            "pulse.default.req" = "2048/48000";
            "pulse.max.req" = "4096/48000";
            "pulse.min.quantum" = "1024/48000";
            "pulse.max.quantum" = "4096/48000";
          };
          "stream.properties" = {
            "node.latency" = "2048/48000";
          };
        };
      };
    };

    security.rtkit.enable = true;
  };
  imports = [./rnnoise.nix];
}
