{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cfg.services.pipewire;
in
{
  options.cfg.services.pipewire.enable = mkEnableOption "pipewire";
  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
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
                # without this, our rnnoise source tries to attach
                # directly to this sink instead of our 1-ch mic.
                "priority.session" = 0;
              };
            }
            {
              # disable nodes that i don't use
              matches = [
                { "node.description" = "~EVO4 Loopback.*"; }
                { "node.description" = "EVO4 Mic 2 / Line 2"; }
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
      # user needs to be in pipewire group fo rtprio
      # https://github.com/NixOS/nixpkgs/blob/177d0540942fb205af6993b1d5fa0b57799e09f8/nixos/modules/services/desktops/pipewire/pipewire.nix#L462
      "pipewire"
    ];
  };
}
