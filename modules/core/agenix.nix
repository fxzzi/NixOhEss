{
  sources,
  pkgs,
  user,
  ...
}: {
  imports = [(sources.agenix + "/modules/age.nix")];
  environment.systemPackages = [(pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" {})];
  age.identityPaths = ["/home/${user}/.ssh/agenix"];
  # SSH keys are stored in user's home. So make sure home dir is mounted to access them at boot
  fileSystems."/home".neededForBoot = true;
}
