{
  lib,
  config,
  pkgs,
  ...
}: {
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
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    networking.firewall = {
      allowedTCPPorts = [
        3074
      ];
      allowedUDPPorts = [
        3074
      ];
    };
  };
}
