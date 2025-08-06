{
  pkgs,
  config,
  npins,
  ...
}: {
  environment.systemPackages = [(pkgs.callPackage "${npins.agenix}/pkgs/agenix.nix" {})];
  imports = [(npins.agenix + "/modules/age.nix")];
  age.identityPaths = ["/home/${config.cfg.core.username}/.ssh/agenix"];
  # SSH keys are stored in user's home. So make sure home dir is mounted to access them at boot
  fileSystems."/home".neededForBoot = true;
}
