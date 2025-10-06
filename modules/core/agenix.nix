{
  pkgs,
  config,
  npins,
  ...
}: {
  environment.systemPackages = [(pkgs.callPackage "${npins.agenix}/pkgs/agenix.nix" {})];
  imports = [(npins.agenix + "/modules/age.nix")];
  age.identityPaths = [
    "/home/${config.cfg.core.username}/.ssh/agenix"
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
