{
  inputs,
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = [inputs.agenix.packages.${pkgs.system}.default];
  imports = [inputs.agenix.nixosModules.default];
  age.identityPaths = ["/home/${user}/.ssh/agenix"];
}
