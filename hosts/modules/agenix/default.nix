{
  system,
  inputs,
	user,
  ...
}: {
  environment.systemPackages = [inputs.agenix.packages.${system}.default];
  imports = [inputs.agenix.nixosModules.default];
	age.identityPaths = [ "/home/${user}/.local/share/ssh/agenix" ];
}
