{hostName, ...}:
{
	imports = [
		./${hostName}.nix
		./hardware-configurations/${hostName}.nix
		./modules
	];
}
