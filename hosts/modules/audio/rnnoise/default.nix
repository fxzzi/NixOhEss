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
          "node.description" = "Noise Canceling source";
          "media.name" = "Noise Canceling source";
          "filter.graph" = {
            "nodes" = [
              {
                "type" = "ladspa";
                "name" = "rnnoise";
                "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                "label" = "noise_suppressor_mono";
                "control" = {
                  "VAD Threshold (%)" = config.audio.pipewire.rnnoise.vadThreshold;
                  "VAD Grace Period (ms)" = config.audio.pipewire.rnnoise.vadGracePeriod;
                  "Retroactive VAD Grace (ms)" = config.audio.pipewire.rnnoise.retroactiveVadGrace;
                };
              }
            ];
          };
          "capture.props" = {
            "node.name" = "effect_input.rnnoise";
            "node.passive" = true;
            "audio.channels" = 1;
            "audio.rate" = 48000;
          };
          "playback.props" = {
            "node.name" = "effect_output.rnnoise";
            "media.class" = "Audio/Source";
            "audio.channels" = 1;
            "audio.rate" = 48000;
          };
        };
      }
    ];
  };
in {
  options.audio.pipewire.rnnoise.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables the rnnoise pipewire plugin for mic noise suppression.";
  };
  options.audio.pipewire.rnnoise.vadThreshold = lib.mkOption {
    type = lib.types.unsignedInt;
    default = 50;
    description = "Set the rnnoise VAD threshold (%)";
  };
  options.audio.pipewire.rnnoise.vadGracePeriod = lib.mkOption {
    type = lib.types.unsignedInt;
    default = 20;
    description = "Set the rnnoise VAD grace period in milliseconds.";
  };
  options.audio.pipewire.rnnoise.retroactiveVadGrace = lib.mkOption {
    type = lib.types.unsignedInt;
    default = 0;
    description = "Set the rnnoise retroactive VAD grace period in milliseconds.";
  };
  config = {
    services.pipewire = lib.mkIf config.audio.pipewire.rnnoise.enable {
      extraConfig.pipewire."99-input-denoising" = pw_rnnoise_config; # Add rnnoise-plugin filters
    };
  };
}
