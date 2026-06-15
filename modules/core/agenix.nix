{
  pkgs,
  config,
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.agenix
  ];
  imports = [inputs.agenix.nixosModules.default];
  age.identityPaths = [
    "${config.hj.directory}/.ssh/agenix"
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
