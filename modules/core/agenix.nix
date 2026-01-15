{
  pkgs,
  config,
  pins,
  ...
}: {
  environment.systemPackages = [(pkgs.callPackage "${pins.agenix}/pkgs/agenix.nix" {})];
  imports = [(pins.agenix + "/modules/age.nix")];
  age.identityPaths = [
    "${config.hj.directory}/.ssh/agenix"
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
