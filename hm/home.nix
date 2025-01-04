{ ... }:
{
  home = {
    username = "faaris";
    homeDirectory = "/home/faaris";
    stateVersion = "24.11"; # Match your NixOS release or Home Manager version
		sessionPath = [
			"$HOME/.local/scripts"
		];
  };
}
