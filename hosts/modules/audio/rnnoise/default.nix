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
                  "VAD Threshold (%)" = 92;
                  "VAD Grace Period (ms)" = 25;
                  "Retroactive VAD Grace (ms)" = 0;
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
  config = {
    services.pipewire = lib.mkIf config.audio.pipewire.rnnoise.enable {
      extraConfig.pipewire."99-input-denoising" = pw_rnnoise_config; # Add rnnoise-plugin filters
    };
  };
}
