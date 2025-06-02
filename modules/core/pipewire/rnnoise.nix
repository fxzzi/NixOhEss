{
  config,
  pkgs,
  lib,
  ...
}: let
  pw_rnnoise_config = {
    "context.modules" = [
      {
        "name" = "libpipewire-module-filter-chain";
        "args" = {
          "node.description" = "Noise Cancelling source";
          "media.name" = "Noise Cancelling source";
          "filter.graph" = {
            "nodes" = [
              {
                "type" = "ladspa";
                "name" = "rnnoise";
                "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                "label" = "noise_suppressor_mono";
                "control" = {
                  "VAD Threshold (%)" = config.cfg.audio.pipewire.rnnoise.vadThreshold;
                  "VAD Grace Period (ms)" = config.cfg.audio.pipewire.rnnoise.vadGracePeriod;
                  "Retroactive VAD Grace (ms)" = config.cfg.audio.pipewire.rnnoise.retroactiveVadGrace;
                };
              }
            ];
          };
          "audio.rate" = 48000;
          "audio.position" = ["MONO"];
          "capture.props" = {
            "node.name" = "capture.rnnoise_source";
            "node.passive" = true;
            "audio.rate" = 48000;
            "audio.channels" = 1;
          };
          "playback.props" = {
            "node.name" = "rnnoise_source";
            "media.class" = "Audio/Source";
            "audio.channels" = 1;
          };
        };
      }
    ];
  };
in {
  options.cfg.audio.pipewire.rnnoise = {
    enable = lib.mkEnableOption "rnnoise";
    vadThreshold = lib.mkOption {
      type = lib.types.int;
      default = 50;
      description = "Set the rnnoise VAD threshold (%)";
    };
    vadGracePeriod = lib.mkOption {
      type = lib.types.int;
      default = 20;
      description = "Set the rnnoise VAD grace period in milliseconds.";
    };
    retroactiveVadGrace = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Set the rnnoise retroactive VAD grace period in milliseconds.";
    };
  };
  config = {
    services.pipewire = lib.mkIf config.cfg.audio.pipewire.rnnoise.enable {
      extraConfig.pipewire."99-input-denoising" = pw_rnnoise_config; # Add rnnoise-plugin filters
    };
  };
}
