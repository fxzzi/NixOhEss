{ ... }:
{
  # never change this. trust me.
  system.stateVersion = "22.11";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.settings.warn-dirty = false;
  nix.settings.use-xdg-base-directories = true;
	imports = [
		./gpu
		./scx
		./user
		./audio
		./fonts
		./batmon
		./cachix
		./gaming
		./kernel
		./wayland
		./services
		./fancontrol
		./networking
		./secureboot
		./opentabletdriver
		# ./getty-tty1-only-password
	];
}
