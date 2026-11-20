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
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
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
