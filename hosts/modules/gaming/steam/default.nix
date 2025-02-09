{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  nixpkgs-proton-ge = inputs.nixpkgs-proton-ge.legacyPackages.${pkgs.system};
in {
  options.gaming.steam.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enables steam.";
  };
  config = lib.mkIf config.gaming.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      extraCompatPackages = [
        nixpkgs-proton-ge.proton-ge-bin
      ];
    };
  };
}
