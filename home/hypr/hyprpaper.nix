{ pkgs, inputs, ... }:
{
	services.hyprpaper = {
		enable = true;
		settings = {
			ipc = 1;
			splash = 0;
		};
	};
}
