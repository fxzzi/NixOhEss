{inputs, ...}: {
  imports = [
    inputs.evoctl-nix.nixosModules.default
  ];
  config = {
    hardware.audient-evo.enable = true;
    services.pipewire = {
      wireplumber.extraConfig."92-audient-evo4" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "alsa.card_name" = "EVO4";
              }
            ];
            actions = {
              update-props = {
                "device.profile" = "pro-audio";
                "node.pause-on-idle" = false;
              };
            };
          }
        ];
      };
      extraConfig.pipewire = {
        "92-audient-evo4" = {
          "context.modules" = [
            {
              name = "libpipewire-module-loopback";
              args = {
                "node.description" = "EVO4 Output";

                "capture.props" = {
                  "node.name" = "EVO4_Output";
                  "media.class" = "Audio/Sink";
                  "audio.position" = ["FL" "FR"];
                };

                "playback.props" = {
                  "node.name" = "playback.EVO4_Output";
                  "audio.position" = ["AUX0" "AUX1"];
                  "node.target" = "alsa_output.usb-Audient_EVO4-00.pro-output-0";
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                };
              };
            }
            {
              name = "libpipewire-module-loopback";
              args = {
                "node.description" = "EVO4 Input";

                "capture.props" = {
                  "node.name" = "capture.EVO4_Input";
                  "audio.position" = ["AUX0"];
                  "node.target" = "alsa_input.usb-Audient_EVO4-00.pro-input-0";
                  "stream.dont-remix" = true;
                  "node.passive" = true;
                };

                "playback.props" = {
                  "node.name" = "EVO4_Input";
                  "media.class" = "Audio/Source";
                  "audio.position" = ["MONO"];
                  # set a very high priority for this input node, so that
                  # the rnnoise source picks it over the regular input.
                  "priority.session" = 10000;
                };
              };
            }
          ];
        };
      };
    };
  };
}
