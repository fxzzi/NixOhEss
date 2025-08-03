{
  inputs,
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [inputs.agenix.packages.${pkgs.system}.default];
  imports = [inputs.agenix.nixosModules.default];
  age.identityPaths = ["/home/${config.cfg.core.username}/.ssh/agenix"];
  # SSH keys are stored in user's home. So make sure home dir is mounted to access them at boot
  fileSystems."/home".neededForBoot = true;
}
