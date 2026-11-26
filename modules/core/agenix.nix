{
  pkgs,
  config,
  inputs,
  ...
}:
{
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  imports = [ inputs.agenix.nixosModules.default ];
  # agenix decrypts during activation, before systemd mounts /home,
  # so the user identity and ~/.ssh targets need it mounted in initrd
  fileSystems."/home".neededForBoot = true;
  age.identityPaths = [
    "${config.hj.directory}/.ssh/id_ed25519"
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
