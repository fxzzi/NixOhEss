{ pkgs, ... }:
{
	home.packages = with pkgs; [
		wallust
		pywalfox-native
		dunst
	];
	home.file.".config/wallust".source = "${./config}";
}
