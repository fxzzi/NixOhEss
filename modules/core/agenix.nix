{
  pkgs,
  config,
  inputs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.callPackage "${inputs.agenix}/pkgs/agenix.nix" { })
  ];
  imports = [ "${inputs.agenix}/modules/age.nix" ];
  age.identityPaths = [
    "${config.hj.directory}/.ssh/agenix"
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
