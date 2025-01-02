{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    prismlauncher
    lutris
		gamemode
		mangohud
  ];
	services.scx = {
		enable = true;
		scheduler = "scx_lavd";
		package = pkgs.scx.rustscheds;
	}; 
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
