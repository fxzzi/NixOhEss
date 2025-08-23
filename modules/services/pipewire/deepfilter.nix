{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.cfg.services.pipewire.deepfilter;
  pw_deepfilter_config = {
    "context.modules" = [
      {
        "name" = "libpipewire-module-filter-chain";
        "args" = {
          "node.description" = "DeepFilter Noise Cancelling Source";
          "media.name" = "DeepFilter Noise Cancelling Source";
          "filter.graph" = {
            "nodes" = [
              {
                "type" = "ladspa";
                "name" = "DeepFilter Mono";
                "plugin" = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
                "label" = "deep_filter_mono";
                "control" = {
                  "Attenuation Limit (dB)" = cfg.attLimit;
                };
              }
            ];
          };
          "audio.rate" = 48000;
          "audio.channels" = 1;
          "audio.position" = ["MONO"];
          "capture.props" = {
            "node.passive" = true;
          };
          "playback.props" = {
            "media.class" = "Audio/Source";
          };
        };
      }
    ];
  };
in {
  options.cfg.services.pipewire.deepfilter = {
    enable = mkEnableOption "deepfilter";
    attLimit = mkOption {
      type = types.int;
      default = 100;
      description = "Set the deepfilter attenuation limit (dB). 100 means no limit.";
    };
  };
  config = {
    services.pipewire = mkIf cfg.enable {
      extraConfig.pipewire."99-input-denoising" = pw_deepfilter_config; # Add deepfilternet filters
    };
  };
}
