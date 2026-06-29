{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.pipewire;
in {
  options.cfg.services.pipewire.enable = mkEnableOption "pipewire";
  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
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
      wireplumber.extraConfig = {
        "9-audient-evo4" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "alsa.card_name" = "EVO4";
                  "media.class" = "Audio/Source/Internal";
                }
                {
                  "alsa.card_name" = "EVO4";
                  "media.class" = "Audio/Sink/Internal";
                }
              ];
              actions.update-props = {
                # decrease priority of the raw hardware devices
                "priority.driver" = 0;
                "priority.session" = 0;
              };
            }
            {
              matches = [
                {
                  "alsa.card_name" = "EVO4";
                  "media.class" = "Audio/Sink/Internal";
                }
              ];
              actions.update-props = {
                # don't suspend the interface, to avoid popping when it wakes.
                "session.suspend-timeout-seconds" = 0;
              };
            }
            {
              # disable nodes that i don't use
              matches = [
                {"node.description" = "~EVO4 Loopback.*";}
                {"node.description" = "EVO4 Mic 2 / Line 2";}
              ];
              actions.update-props = {
                "node.disabled" = true;
              };
            }
          ];
        };
      };
    };
    hj.packages = with pkgs; [
      qpwgraph
      pwvucontrol
      alsa-utils
    ];
    users.users.${config.cfg.core.username}.extraGroups = [
      "audio"
      "pipewire"
    ];
  };
}
