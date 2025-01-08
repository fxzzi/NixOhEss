{hostName, user, inputs, npins, ...}:
{
	imports = [
		./${hostName}.nix
		./hardware-configurations/${hostName}.nix
		./modules
	];
home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    users.${user} = import ../home/${hostName}.nix;
    extraSpecialArgs = {
      inherit
        inputs
        npins
        user
        hostName
        ;
    };
  };

}
