{ ... }:
{

  home.username = "faaris";
  home.homeDirectory = "/home/faaris";

  home.stateVersion = "24.11"; # Match your NixOS release or Home Manager version

  imports = [
		./zsh.nix
	];
}
