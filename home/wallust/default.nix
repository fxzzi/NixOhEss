{ pkgs, ... }:
{
	home.packages = with pkgs; [
		wallust
		dunst
	];
	home.file.".config/wallust".source = "${./config}";
}
