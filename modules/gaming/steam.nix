{
  lib,
  config,
  pkgs,
  ...
}: {
  options.cfg.gaming.steam.enable = lib.mkEnableOption "steam";
  config = lib.mkIf config.cfg.gaming.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
